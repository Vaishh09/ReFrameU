import SwiftUI

struct MoodProgressView: View {
    var moodToLog: String? = nil
    @State private var moodLog: [String] = []
    @State private var level = 1
    @State private var streak = 0

    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    let dayPlants: [String: String] = [
        "Mon": "🌱",
        "Tue": "🌿",
        "Wed": "🌷",
        "Thu": "🌸",
        "Fri": "🌼",
        "Sat": "🪴",
        "Sun": "🌳"
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
                    gradient: Gradient(colors: [
                        Color.green.opacity(0.2),
                        Color.blue.opacity(0.2)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 20) {
                        Text("🌿 Mood Tracker")
                            .font(.title2)
                            .fontWeight(.semibold)

                        NavigationLink("Reflect & Reframe") {
                            ThoughtInputView()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)

                        Button("Did you log today?") {
                            if let mood = moodToLog {
                                logMood(for: mood)
                            } else {
                                print("❗ No mood passed")
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(12)

                        Text("\(plantEmoji) Garden Level: \(level)")
                            .font(.headline)

                        if streak >= 3 {
                            Text("🔥 Streak: \(streak) days!")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                        }

                        VStack(spacing: 12) {
                            ForEach(0..<weeksCount, id: \.self) { weekIndex in
                                HStack(spacing: 12) {
                                    ForEach(0..<7, id: \.self) { dayIndex in
                                        let overallIndex = weekIndex * 7 + dayIndex
                                        if overallIndex < moodLog.count {
                                            let day = moodLog[overallIndex]
                                            VStack(spacing: 4) {
                                                Text(dayPlants[day] ?? "🌿")
                                                    .font(.largeTitle)
                                                Text(day)
                                                    .font(.caption2)
                                            }
                                        } else {
                                            VStack(spacing: 4) {
                                                Text("❔")
                                                    .font(.largeTitle)
                                                Text("...")
                                                    .font(.caption2)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 20)
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
            if moodLog.count % 3 == 0 {
                level += 1
            }
            streak += 1
        FirestoreManager.shared.saveMood(name: moodName, emoji: "🌿")
        }
}

