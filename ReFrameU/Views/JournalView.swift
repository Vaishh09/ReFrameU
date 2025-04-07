import SwiftUI

struct JournalView: View {
    @State private var journalEntries: [String] = []
    @State private var showNewEntrySheet: Bool = false
    @State private var newEntryText: String = ""
    @State private var calmnessValue: Double = 5.0
    
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
                    VStack(spacing: 12) {
                        Text("How calm are you feeling?")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.15))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Uncalm")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("Calm")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)
                                
                                Slider(value: $calmnessValue, in: 0...10, step: 1) {
                                    Text("Calmness Slider")
                                }
                                .tint(colorForCalmness(calmnessValue))
                                .padding(.horizontal, 16)
                                
                                Text("Calmness Level: \(Int(calmnessValue))")
                                    .font(.subheadline)
                                    .foregroundColor(colorForCalmness(calmnessValue))
                            }
                            .padding(.vertical, 12)
                        }
                        .frame(height: 120)
                        .padding(.horizontal)
                    }
                    
                    if journalEntries.isEmpty {
                        Text("No journal entries yet. Add one!")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(journalEntries, id: \.self) { entry in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(entry)
                                            .foregroundColor(.black)
                                            .padding()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showNewEntrySheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("New Journal Entry")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 10)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Journal")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .sheet(isPresented: $showNewEntrySheet) {
                JournalEntrySheet(
                    journalEntries: $journalEntries,
                    newEntryText: $newEntryText,
                    showSheet: $showNewEntrySheet
                )
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    NavigationLink(destination: SettingsView()) {
                        VStack {
                            Image(systemName: "gearshape")
                            Text("Settings")
                        }
                    }
                    Spacer()
                    
                    NavigationLink(destination: MoodProgressView(moodToLog: nil)) {
                        VStack {
                            Image(systemName: "heart.text.square")
                            Text("Mood")
                        }
                    }
                    Spacer()
                    
                    NavigationLink(destination: JournalView()) {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                    }
                    Spacer()
                    
                    NavigationLink(destination: ProfileView()) {
                        VStack {
                            Image(systemName: "person.crop.circle")
                            Text("Profile")
                        }
                    }
                    Spacer()
                    
                    NavigationLink(destination: ThoughtInputView()) {
                        VStack {
                            Image(systemName: "quote.bubble.fill")
                            Text("Reframe")
                        }
                    }
                }
            }
        }
    }
    
    func colorForCalmness(_ value: Double) -> Color {
        let ratio = value / 10.0
        // Interpolate hue from red (0.0) to green (~0.33)
        let hue = 0.33 * ratio
        return Color(hue: hue, saturation: 0.8, brightness: 0.9)
    }
}

struct JournalEntrySheet: View {
    @Binding var journalEntries: [String]
    @Binding var newEntryText: String
    @Binding var showSheet: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $newEntryText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                Spacer()
            }
            .padding()
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showSheet = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !newEntryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            journalEntries.append(newEntryText)
                        }
                        newEntryText = ""
                        showSheet = false
                    }
                }
            }
        }
    }
}

// MARK: - Placeholder Views for Toolbar Navigation

struct ProfileView: View {
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
                
                Text("Profile Page")
                    .font(.largeTitle)
            }
            .navigationTitle("Profile")
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    JournalView()
}
