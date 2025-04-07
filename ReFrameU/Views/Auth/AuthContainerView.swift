import SwiftUI

struct AuthContainerView: View {
    @Binding var isAuthenticated: Bool
    @State private var showLogin = true

    var body: some View {
        if showLogin {
            LoginView(isAuthenticated: $isAuthenticated, showLogin: $showLogin)
        } else {
            CreateAccountView(isAuthenticated: $isAuthenticated, showLogin: $showLogin)
        }
    }
}
