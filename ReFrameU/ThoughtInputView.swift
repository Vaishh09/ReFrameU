import SwiftUI

struct ThoughtInputView: View {
    @State private var userThought = ""
    @State private var selectedMoodIndex = 0

    let moods: [(name: String, emoji: String)] = [
        ("Happy", "😄"),
        ("Sad", "😢"),
        ("Anxious", "😰"),
        ("Peaceful", "🧘‍♀️"),
        ("Angry", "😡"),
        ("Nervous", "😬"),
        ("Excited", "🤩"),
        ("Tired", "😴"),
        ("Motivated", "💪"),
        ("Grateful", "🙏"),
        ("Overwhelmed", "🥵"),
        ("Content", "😊"),
        ("Hopeful", "🌈")
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

                VStack(spacing: 20) {
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
                    .frame(height: 150)
                    .clipped()

                    Text("Reflect on Your Thought")
                        .font(.title2)
                        .fontWeight(.semibold)

                    TextEditor(text: $userThought)
                        .frame(height: 150)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                    Button("Generate Reframed Thought") {
                    }
                    .disabled(userThought.isEmpty)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)

                    NavigationLink(destination: MoodProgressView()) {
                        Text("Check Your Garden")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Spacer()
                }
                .padding()
                .navigationTitle("Reframe a Thought")
            }
        }
    }
}

#Preview {
    ThoughtInputView()
}
