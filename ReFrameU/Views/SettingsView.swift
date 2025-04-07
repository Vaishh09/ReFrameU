import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = true
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.circle.fill")
                    }
                    .onChange(of: isDarkMode) { newValue in
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = newValue ? .dark : .light
                    }
                }

                Section(header: Text("Resources")) {
                    Link(destination: URL(string: "https://wellness.asu.edu/online-programs/mental-well-being")!) {
                        Label("Mental Well-Being Programs", systemImage: "link")
                    }
                    Link(destination: URL(string: "https://eoss.asu.edu/counseling")!) {
                        Label("Counseling Services", systemImage: "person.2.circle")
                    }
                }

                Section(header: Text("App Info")) {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }

                Section {
                    Button(role: .destructive) {
                        do {
                            try Auth.auth().signOut()
                            isAuthenticated = false
                        } catch {
                            print("❌ Sign out failed:", error.localizedDescription)
                        }
                    } label: {
                        Label("Sign Out", systemImage: "arrowshape.turn.up.left")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
