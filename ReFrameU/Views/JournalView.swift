import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct JournalEntry: Identifiable {
    var id: String
    var calmness: Int
    var timestamp: Date
    var answers: [String: String]
}

struct JournalView: View {
    @State private var calmnessLevel: Double = 5
    @State private var responses: [String: String] = [:]
    @State private var pastEntries: [JournalEntry] = []

    let prompts = [
        "What are you most grateful for today?",
        "What is something you learned today?",
        "What are you looking forward to this week?",
        "What are you proud of accomplishing recently?"
    ]

    var moodEmoji: String {
        switch calmnessLevel {
        case 0..<4: return "😣"
        case 4..<7: return "😐"
        default: return "😊"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.4), Color.blue.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        Text("📖 Daily Reflection")
                            .font(.largeTitle.bold())

                        VStack(spacing: 6) {
                            Text("How calm are you feeling?")
                                .font(.headline)

                            HStack {
                                Text("Uncalm")
                                Spacer()
                                Text("Calm")
                            }
                            .font(.caption)

                            Slider(value: $calmnessLevel, in: 1...10, step: 1)
                                .accentColor(.purple)

                            Text("Calmness Level: \(Int(calmnessLevel)) \(moodEmoji)")
                                .foregroundColor(.purple)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)

                        VStack(spacing: 20) {
                            ForEach(prompts, id: \.self) { prompt in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(prompt)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.secondary)

                                    TextEditor(text: Binding(
                                        get: { responses[prompt] ?? "" },
                                        set: { responses[prompt] = $0 }
                                    ))
                                    .frame(height: 80)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 1)
                                }
                            }
                        }

                        Button(action: {
                            saveJournalEntry()
                        }) {
                            Text("+ New Journal Entry")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }

                        if !pastEntries.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("📚 Past Entries")
                                    .font(.headline)

                                ForEach(pastEntries) { entry in
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("🕒 \(entry.timestamp.formatted(date: .abbreviated, time: .shortened))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)

                                        Text("Calmness: \(entry.calmness) \(emojiFor(entry.calmness))")
                                            .font(.caption)

                                        ForEach(entry.answers.sorted(by: { $0.key < $1.key }), id: \.key) { prompt, response in
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("• \(prompt)")
                                                    .font(.caption2)
                                                    .foregroundColor(.gray)
                                                Text(response)
                                                    .font(.body)
                                            }
                                        }
                                    }
                                    .padding(10)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                fetchJournalEntries()
            }
        }
    }

    func emojiFor(_ level: Int) -> String {
        switch level {
        case 0..<4: return "😣"
        case 4..<7: return "😐"
        default: return "😊"
        }
    }

    func saveJournalEntry() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let entryData: [String: Any] = [
            "calmness": Int(calmnessLevel),
            "answers": responses,
            "timestamp": FieldValue.serverTimestamp()
        ]

        Firestore.firestore()
            .collection("journalEntries")
            .document(userId)
            .collection("entries")
            .addDocument(data: entryData) { error in
                if let error = error {
                    print("❌ Error saving journal:", error.localizedDescription)
                } else {
                    print("✅ Journal saved!")
                    responses = [:]
                    fetchJournalEntries()
                }
            }
    }

    func fetchJournalEntries() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore()
            .collection("journalEntries")
            .document(userId)
            .collection("entries")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let docs = snapshot?.documents {
                    self.pastEntries = docs.compactMap { doc in
                        guard let calm = doc["calmness"] as? Int,
                              let answers = doc["answers"] as? [String: String],
                              let ts = doc["timestamp"] as? Timestamp else { return nil }

                        return JournalEntry(id: doc.documentID, calmness: calm, timestamp: ts.dateValue(), answers: answers)
                    }
                }
            }
    }
}

#Preview {
    JournalView()
}
