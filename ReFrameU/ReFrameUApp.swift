import SwiftUI
import FirebaseCore

@main
struct ReFrameUApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
