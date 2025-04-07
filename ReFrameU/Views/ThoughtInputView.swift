import SwiftUI

struct ThoughtRequest: Codable {
    let userThought: String
}

struct ReframeResponse: Codable {
    let logical: String
    let optimistic: String
    let compassionate: String
}

struct ThoughtInputView: View {
    @State private var userThought = ""
    @State private var selectedMoodIndex = 0
    @State private var reframes: [String] = []
    @State private var isLoading = false
    @State private var selectedReframe: String? = nil
    @State private var showPopup: Bool = false
    @State private var moodSlider: Double = 50
    @State private var affirmation = ""
    @State private var challengePrompt = ""

    @AppStorage("savedReframes") private var savedReframes: String = ""

    let moods: [(name: String, emoji: String)] = [
        ("Happy", "😄"), ("Sad", "😢"), ("Anxious", "😰"), ("Peaceful", "🧘‍♀️"),
        ("Angry", "😡"), ("Nervous", "😬"), ("Excited", "🤩"), ("Tired", "😴"),
        ("Motivated", "💪"), ("Grateful", "🙏"), ("Overwhelmed", "🥵"),
        ("Content", "😊"), ("Hopeful", "🌈")
    ]

    let affirmations = [
        "You’re doing better than you think 🌟",
        "Small steps matter 💚",
        "Breathe. You've got this. 💫",
        "Every thought matters 🧠"
    ]

    let challenges = [
        "Reframe a thought using only 5 words.",
        "Be your own best friend.",
        "Imagine someone kind replied to you.",
        "What's the silver lining here?"
    ]

    var moodLabel: String {
        switch moodSlider {
        case 0..<30: return "😢 Low"
        case 30..<70: return "😐 Neutral"
        default: return "😄 High"
        }
    }

    var plantEmoji: String {
        switch reframes.count {
        case 0...2: return "🌱"
        case 3...5: return "🌿"
        case 6...8: return "🌸"
        default: return "🌳"
        }
    }

    var vibeBadge: String {
        let mood = moods[selectedMoodIndex].name
        switch mood {
        case "Angry": return "Fire Starter 🔥"
        case "Tired": return "Gentle Cloud ☁️"
        case "Happy": return "Joy Jumper 🌟"
        default: return "Mind Explorer 🧭"
        }
    }

    var backgroundGradient: LinearGradient {
        switch moods[selectedMoodIndex].name {
        case "Angry": return LinearGradient(colors: [.red.opacity(0.3), .orange.opacity(0.2)], startPoint: .top, endPoint: .bottom)
        case "Peaceful": return LinearGradient(colors: [.purple.opacity(0.3), .blue.opacity(0.2)], startPoint: .top, endPoint: .bottom)
        case "Sad": return LinearGradient(colors: [.blue.opacity(0.3), .gray.opacity(0.2)], startPoint: .top, endPoint: .bottom)
        default: return LinearGradient(colors: [.purple.opacity(0.15), .blue.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        Text("🌈 Reframe a Thought")
                            .font(.largeTitle.bold())
                            .padding(.top)
                            .foregroundColor(.primary)

                        GroupBox(label: Label("Mood Check-In", systemImage: "face.smiling.fill")) {
                            VStack(spacing: 10) {
                                Picker("Mood", selection: $selectedMoodIndex) {
                                    ForEach(moods.indices, id: \.self) { i in
                                        Text("\(moods[i].emoji) \(moods[i].name)").tag(i)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 100)

                                Slider(value: $moodSlider, in: 0...100)
                                    .tint(.cyan)

                                HStack {
                                    Text("Mood: \(moodLabel)")
                                    Spacer()
                                    Text("🎮 \(vibeBadge)")
                                }
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }
                            .padding(8)
                        }

                        GroupBox(label: Label("Reflect on Your Thought", systemImage: "pencil")) {
                            TextEditor(text: $userThought)
                                .frame(height: 120)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }

                        Button(action: {
                            print("🧪 Sending thought to backend: \(userThought)")
                            generateReframes()
                        }) {
                            Label("Generate Reframes", systemImage: "sparkles")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green.gradient)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                        }
                        .disabled(userThought.isEmpty)

                        if isLoading {
                            ProgressView("Reframing with care...")
                        }

                        VStack(spacing: 14) {
                            if reframes.isEmpty && !isLoading {
                                Text("No reframes to show yet.")
                                    .foregroundColor(.gray)
                            }

                            ForEach(reframes, id: \.self) { reframe in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(reframe)
                                        .foregroundColor(.primary)

                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            print("💾 Saved reframe: \(reframe)")
                                            saveReframe(reframe)
                                        }) {
                                            Image(systemName: "tray.and.arrow.down.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.yellow.opacity(0.15))
                                .cornerRadius(12)
                                .shadow(radius: 2)
                            }
                        }

                        VStack(spacing: 6) {
                            Text("\(plantEmoji) Your Thought Garden")
                                .font(.title3.bold())
                            Text("You’ve grown \(reframes.count) reframes today 🌱")
                                .font(.caption)
                        }

                        VStack(spacing: 4) {
                            Text("📌 Daily Reframe Challenge")
                                .font(.headline)
                            Text(challengePrompt)
                                .font(.subheadline)
                                .italic()
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }

                        VStack(spacing: 4) {
                            Text("🗯️ Affirmation of the Day")
                                .font(.headline)
                            Text(affirmation)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }

                        NavigationLink(destination: MoodProgressView(moodToLog: nil)) {
                            Label("Check Your Garden", systemImage: "leaf.fill")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.teal.gradient)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                        }
                    }
                    .padding()
                    .onAppear {
                        affirmation = affirmations.randomElement() ?? "You matter 🌟"
                        challengePrompt = challenges.randomElement() ?? "Reflect with kindness."
                    }
                }
                .navigationTitle("")
                .sheet(isPresented: $showPopup) {
                    ReframePopup(reframe: selectedReframe ?? "", saveAction: saveReframe)
                }
            }
        }
    }

    func generateReframes() {
        isLoading = true
        reframes = []

        ChatbotAPI.shared.sendToReffie(userThought) { responseText in
            isLoading = false

            guard let responseText = responseText else {
                print("🚫 No response from Reffie")
                return
            }

            let lines = responseText.components(separatedBy: "\n")
            let parsed = lines.compactMap { line -> String? in
                if line.lowercased().starts(with: "logical:") ||
                   line.lowercased().starts(with: "optimistic:") ||
                   line.lowercased().starts(with: "compassionate:") {
                    return line.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                return nil
            }

            DispatchQueue.main.async {
                print("✅ Parsed reframes: \(parsed)")
                withAnimation {
                    reframes = parsed
                }
            }
        }
    }

    func saveReframe(_ text: String) {
        FirestoreManager.shared.saveReframe(text: text) { error in
            if let error = error {
                print("❌ Firestore save failed:", error.localizedDescription)
            } else {
                print("✅ Reframe saved to Firestore")
            }
        }
    }
}

struct ReframePopup: View {
    let reframe: String
    let saveAction: (String) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let parts = reframe.split(separator: ":", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let title = parts.first ?? "Reframe"
        let body = parts.count > 1 ? parts[1] : "No content available."

        return VStack(spacing: 20) {
            Text(title)
                .font(.headline)

            ScrollView {
                Text(body)
                    .multilineTextAlignment(.leading)
                    .padding()
            }

            HStack(spacing: 16) {
                Button(action: {
                    print("📦 Popup save: \(reframe)")
                    saveAction(reframe)
                    dismiss()
                }) {
                    Image(systemName: "tray.and.arrow.down.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }

                Button("Close") {
                    dismiss()
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    ThoughtInputView()
}
