import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MoodProgressView: View {
    @State private var calendarDates: [String] = []
    @State private var moodLog: [String: String] = [:]
    @State private var journalLog: [String: String] = [:]
    @State private var selectedDate: String? = nil
    @State private var showPopup = false

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let dayAbbreviations = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.2), Color.teal.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("📆 Mood Mixology")
                        .font(.largeTitle.bold())

                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(dayAbbreviations.indices, id: \.self) { index in
                            Text(dayAbbreviations[index])
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                        }

                        ForEach(calendarDates, id: \.self) { date in
                            let mood = moodLog[date]
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(mood == nil ? Color.gray.opacity(0.2) : Color.green.opacity(0.6))

                                VStack {
                                    Text(formattedDay(from: date))
                                        .font(.caption)
                                        .foregroundColor(.black)

                                    if let mood = mood {
                                        Text(emojiForMood(mood))
                                            .font(.title2)
                                    }
                                }
                                .padding(6)
                            }
                            .frame(minHeight: 50)
                            .onTapGesture {
                                selectedDate = date
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    showPopup = true
                                }
                            }
                        }
                    }

                    Button {
                        showPopup = false
                    } label: {
                        NavigationLink(destination: JournalView()) {
                            Text("Journaled Today?")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.teal.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.top, 20)

                    Spacer()
                }
                .padding()
                .onAppear {
                    generateCalendar()
                    fetchMoodLogs()
                    fetchJournalEntries()
                }
            }
            .sheet(isPresented: $showPopup) {
                MoodDetailPopup(
                        date: "2025-04-06"
                    )
            }
        }
    }

    func generateCalendar() {
        let calendar = Calendar.current
        let today = Date()

        guard let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) else { return }

        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let startOffset = weekday - calendar.firstWeekday
        let startDate = calendar.date(byAdding: .day, value: -startOffset, to: firstOfMonth)!

        calendarDates = (0..<42).compactMap {
            let date = calendar.date(byAdding: .day, value: $0, to: startDate)!
            return formattedDate(date)
        }
    }

    func fetchMoodLogs() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore()
            .collection("moodLogs")
            .document(userId)
            .collection("logs")
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents, error == nil else {
                    print("❌ Failed to fetch mood logs:", error?.localizedDescription ?? "")
                    return
                }

                var newLog: [String: String] = [:]
                for doc in docs {
                    if let mood = doc.data()["mood"] as? String {
                        newLog[doc.documentID] = mood
                    }
                }
                DispatchQueue.main.async {
                    moodLog = newLog
                }
            }
    }

    func fetchJournalEntries() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore()
            .collection("journalEntries")
            .document(userId)
            .collection("entries")
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents, error == nil else {
                    print("❌ Failed to fetch journal entries:", error?.localizedDescription ?? "")
                    return
                }

                var entries: [String: String] = [:]
                for doc in docs {
                    if let ts = doc["timestamp"] as? Timestamp,
                       let entry = doc["entry"] as? String {
                        let dateStr = formattedDate(ts.dateValue())
                        entries[dateStr] = entry
                    }
                }

                DispatchQueue.main.async {
                    journalLog = entries
                }
            }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    func formattedDay(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            let day = Calendar.current.component(.day, from: date)
            return String(day)
        }
        return ""
    }

    func emojiForMood(_ mood: String) -> String {
        switch mood.lowercased() {
        case "happy": return "😄"
        case "sad": return "😢"
        case "anxious": return "😰"
        case "peaceful": return "🧘‍♀️"
        case "angry": return "😡"
        case "nervous": return "😬"
        case "excited": return "🤩"
        case "tired": return "😴"
        case "motivated": return "💪"
        case "grateful": return "🙏"
        case "overwhelmed": return "🥵"
        case "content": return "😊"
        case "hopeful": return "🌈"
        default: return "🌿"
        }
    }
}


struct MoodDetailPopup: View {
    let date: String

    var body: some View {
        VStack(spacing: 16) {
            Text("📅 \(date)")
                .font(.headline)

            Text("Mood: Happy \(emojiForMood("Happy"))")
                .font(.subheadline)

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Journal Entry:")
                    .font(.headline)
                Text("Today I felt really accomplished after finishing all my tasks early. I treated myself to a walk outside!")
                    .font(.body)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
    }

    func emojiForMood(_ mood: String) -> String {
        switch mood.lowercased() {
        case "happy": return "😄"
        case "sad": return "😢"
        case "anxious": return "😰"
        case "peaceful": return "🧘‍♀️"
        case "angry": return "😡"
        case "nervous": return "😬"
        case "excited": return "🤩"
        case "tired": return "😴"
        case "motivated": return "💪"
        case "grateful": return "🙏"
        case "overwhelmed": return "🥵"
        case "content": return "😊"
        case "hopeful": return "🌈"
        default: return "🌿"
        }
    }
}
