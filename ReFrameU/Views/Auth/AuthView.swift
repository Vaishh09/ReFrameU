import SwiftUI

struct AuthView: View {
    @AppStorage("isAuthenticated") private var isAuthenticated = AuthManager.shared.isLoggedIn()

    var body: some View {
        if isAuthenticated {
            MainTabView()
        } else {
            AuthContainerView(isAuthenticated: $isAuthenticated)
        }
    }
}
