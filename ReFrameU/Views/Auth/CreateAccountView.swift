import SwiftUI

struct CreateAccountView: View {
    @Binding var isAuthenticated: Bool
    @Binding var showLogin: Bool
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            GardenBackgroundView()

            VStack(spacing: 20) {
                Spacer()

                VStack(spacing: 16) {
                    Text("Create Account 🌱")
                        .font(.title2)
                        .fontWeight(.bold)

                    TextField("Full Name", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                    Button("Sign Up") {
                        AuthManager.shared.signUp(name: name, email: email, password: password) { result in
                            switch result {
                            case .success:
                                isAuthenticated = true
                            case .failure(let error):
                                print("❌ Signup failed:", error.localizedDescription)
                            }
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)

                    Button("Already have an account? Log in") {
                        showLogin = true
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
