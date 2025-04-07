import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @Binding var showLogin: Bool
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            GardenBackgroundView()

            VStack(spacing: 20) {
                Spacer()

                VStack(spacing: 16) {
                    Text("Welcome Back 🌿")
                        .font(.title2)
                        .fontWeight(.bold)

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                    Button("Login") {
                        AuthManager.shared.signIn(email: email, password: password) { result in
                            switch result {
                            case .success:
                                isAuthenticated = true
                            case .failure(let error):
                                print("❌ Login failed:", error.localizedDescription)
                            }
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)

                    Button("Don't have an account? Sign up") {
                        showLogin = false
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }
                .padding()
                .background(Color.white.opacity(0.95))
                .cornerRadius(16)
                .shadow(radius: 5)
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
}
