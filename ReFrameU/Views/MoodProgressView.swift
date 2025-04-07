// MARK: - MOOD PROGRESS VIEW
import SwiftUI
struct MoodProgressView: View {
    var moodToLog: String? = nil
    @State private var moodLog: [String] = []
    @State private var level = 1
    @State private var streak = 0
    @State private var moodNotes: [Int: String] = [:]
    @State private var showNoteInput = false
    @State private var noteInput = ""
    @State private var selectedDayIndex: Int?

    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    let dayPlants: [String: String] = [
        "Mon": "🌱", "Tue": "🌿", "Wed": "🌷", "Thu": "🌸",
        "Fri": "🌼", "Sat": "🪴", "Sun": "🌳"
    ]

    var plantEmoji: String {
        switch level {
        case 1: return "🌱"
        case 2: return "🌿"
        case 3: return "🌸"
        case 4: return "🌼"
        default: return "🌳"
        }
    }

    var weeksCount: Int {
        (moodLog.count + 6) / 7
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.2), Color.teal.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        Text("🌿 Mood Tracker")
                            .font(.largeTitle.bold())

                        NavigationLink(destination: ThoughtInputView()) {
                            Label("Reflect & Reframe", systemImage: "wand.and.stars")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }

                        Button("Did you log today?") {
                            if let mood = moodToLog {
                                logMood(for: mood)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .foregroundColor(.white)
                        .cornerRadius(12)

                        VStack(spacing: 6) {
                            Text("\(plantEmoji) Garden Level: \(level)")
                                .font(.title3)
                            if streak >= 3 {
                                Text("🔥 \(streak)-day Streak!")
                                    .foregroundColor(.orange)
                            }
                        }

                        VStack(spacing: 16) {
                            ForEach(0..<weeksCount, id: \.self) { weekIndex in
                                HStack(spacing: 12) {
                                    ForEach(0..<7, id: \.self) { dayIndex in
                                        let overallIndex = weekIndex * 7 + dayIndex
                                        if overallIndex < moodLog.count {
                                            let day = moodLog[overallIndex]
                                            VStack(spacing: 6) {
                                                Button(action: {
                                                    selectedDayIndex = overallIndex
                                                    noteInput = moodNotes[overallIndex] ?? ""
                                                    showNoteInput = true
                                                }) {
                                                    VStack {
                                                        Text(dayPlants[day] ?? "🌿")
                                                            .font(.largeTitle)
                                                        Text(day)
                                                            .font(.caption2)
                                                    }
                                                }
                                                if let note = moodNotes[overallIndex], !note.isEmpty {
                                                    Text("📝 \(note)")
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                        } else {
                                            VStack(spacing: 4) {
                                                Text("❔").font(.largeTitle)
                                                Text("...").font(.caption2)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .sheet(isPresented: $showNoteInput) {
                    VStack(spacing: 16) {
                        Text("📝 Add a Note for the Day")
                            .font(.headline)
                        TextField("What happened today?", text: $noteInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Save") {
                            if let index = selectedDayIndex {
                                moodNotes[index] = noteInput
                            }
                            showNoteInput = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            if let mood = moodToLog {
                logMood(for: mood)
            }
        }
    }

    func logMood(for mood: String? = nil) {
        let moodName = mood ?? days[moodLog.count % 7]
        moodLog.append(moodName)
        if moodLog.count % 3 == 0 { level += 1 }
        streak += 1
        FirestoreManager.shared.saveMood(name: moodName, emoji: "🌿")
    }
}
