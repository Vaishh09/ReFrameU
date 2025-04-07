import SwiftUI

struct SettingsView: View {
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
                    Text("Settings")
                        .font(.title2)
                        .fontWeight(.semibold)

                    List {
                        Section {
                            NavigationLink("Account Details", destination: AccountDetailsView())
                        }
                        
                        Section(header: Text("Helpful Resources")) {
                            NavigationLink("View ASU Mental Health Resources", destination: ResourcesView())
                        }
                        
                        Section {
                            Button {
                                print("User logged out.")
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Log Out")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .scrollContentBackground(.hidden)  // remove white BG behind list
                    .background(Color.clear)
                }
                .padding(.horizontal)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    // Already on Settings
                    Button {
                        print("Already on Settings!")
                    } label: {
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
}

struct AccountDetailsView: View {
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
                    Text("Account Details")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("Here you can show user info, etc.")
                        .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        // Optionally navigate back or do nothing
                        print("Already on Account Details!")
                    } label: {
                        VStack {
                            Image(systemName: "person.fill")
                            Text("Account")
                        }
                    }
                    // ... or replicate your bottom toolbar if desired
                }
            }
        }
    }
}

struct ResourcesView: View {
    let resources: [(name: String, url: String)] = [
        ("ASU Counseling & Psychological Services (CAPS)", "https://students.asu.edu/counseling"),
        ("ASU Student Health Services - Mental Health", "https://students.asu.edu/health"),
        ("ASU Wellbeing", "https://wellbeing.asu.edu/"),
        ("ASU Crisis Line", "tel:18552601010"),
        ("Emergency (911)", "tel:911")
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
                    Text("Resources")
                        .font(.title2)
                        .fontWeight(.semibold)

                    List(resources, id: \.name) { resource in
                        if let url = URL(string: resource.url) {
                            Link(resource.name, destination: url)
                        } else {
                            Text(resource.name)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                .padding(.horizontal)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        print("Already on Resources!")
                    } label: {
                        VStack {
                            Image(systemName: "book.fill")
                            Text("Resources")
                        }
                    }
                    // ... or replicate your bottom toolbar if you want
                }
            }
        }
    }
}


#Preview {
    SettingsView()
}
