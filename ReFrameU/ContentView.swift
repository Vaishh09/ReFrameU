import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ThoughtInputView()
            }
            .tabItem {
                Label("Reframe", systemImage: "bubble.left.and.bubble.right")
            }

            NavigationStack {
                ToolboxView()
            }
            .tabItem {
                Label("Toolbox", systemImage: "archivebox")
            }

            NavigationStack {
                MoodProgressView()
            }
            .tabItem {
                Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
            }
        }
        .accentColor(Color("blue"))
    }
}
