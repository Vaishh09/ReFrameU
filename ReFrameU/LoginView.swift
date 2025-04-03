//
//  LoginView.swift
//  ReFrameU
//
//  Created by Vaishnavi Mahajan on 4/3/25.
//


import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
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
                        .frame(maxWidth: .infinity)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity)
                    
                    Button("Forgot Password?") {}
                        .font(.footnote)
                        .foregroundColor(.green)
                    
                    Button(action: {
                        if !email.isEmpty && !password.isEmpty {
                            isAuthenticated = true
                        }
                    }) {
                        Text("Log In")
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

#Preview{
    
}
