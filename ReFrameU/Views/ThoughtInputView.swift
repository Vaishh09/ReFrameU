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

    @AppStorage("savedReframes") private var savedReframes: String = ""

    let moods: [(name: String, emoji: String)] = [
        ("Happy", "😄"), ("Sad", "😢"), ("Anxious", "😰"), ("Peaceful", "🧘‍♀️"),
        ("Angry", "😡"), ("Nervous", "😬"), ("Excited", "🤩"), ("Tired", "😴"),
        ("Motivated", "💪"), ("Grateful", "🙏"), ("Overwhelmed", "🥵"),
        ("Content", "😊"), ("Hopeful", "🌈")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.green.opacity(0.2),
                        Color.blue.opacity(0.2)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("How are you feeling today?")
                            .font(.headline)

                        Picker("Select Mood", selection: $selectedMoodIndex) {
                            ForEach(moods.indices, id: \.self) { i in
                                HStack {
                                    Text(moods[i].emoji)
                                        .font(.largeTitle)
                                    Text(moods[i].name)
                                }
                                .tag(i)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 120)
                        .clipped()
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Reflect on Your Thought")
                            .font(.title2)
                            .fontWeight(.semibold)

                        TextEditor(text: $userThought)
                            .frame(height: 120)
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }

                    Button("Generate Reframes") {
                        print("🧪 Sending thought to backend: \(userThought)")
                        generateReframes()
                    }
                    .disabled(userThought.isEmpty)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)

                    if isLoading {
                        ProgressView("Reframing with care...")
                    }

                    ScrollView {
                        VStack(spacing: 12) {
                            if reframes.isEmpty && !isLoading {
                                Text("No reframes to show yet.")
                                    .foregroundColor(.gray)
                            }
                            ForEach(reframes, id: \.self) { reframe in
                                VStack(alignment: .leading) {
                                    HStack(alignment: .top) {
                                        Text(reframe)
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.leading)

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
                                .background(Color(red: 1.0, green: 0.95, blue: 0.75))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top, 10)
                    }

                    NavigationLink(destination: MoodProgressView(moodToLog: nil)) {
                        Text("Check Your Garden")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .navigationTitle("Reframe a Thought")
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
