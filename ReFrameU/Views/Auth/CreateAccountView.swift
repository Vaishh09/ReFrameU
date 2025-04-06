//
//  CreateAccountView.swift
//  ReFrameU
//
//  Created by Vaishnavi Mahajan on 4/3/25.
//

import SwiftUI

struct CreateAccountView: View {
    @Binding var isAuthenticated: Bool
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
                        .frame(maxWidth: .infinity)

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity)

                    Button(action: {
                        if !email.isEmpty && !password.isEmpty && !name.isEmpty {
                            AuthManager.shared.signUp(email: email, password: password) { result in
                                switch result {
                                case .success:
                                    print("✅ Successfully signed up")
                                    DispatchQueue.main.async {
                                        isAuthenticated = true
                                    }
                                case .failure(let error):
                                    print("❌ Signup failed:", error.localizedDescription)
                                }
                            }
                        }
                    }) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
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
