//
//  AuthContainerView.swift
//  ReFrameU
//
//  Created by Vaishnavi Mahajan on 4/3/25.
//


import SwiftUI
import Foundation

extension Notification.Name {
    static let toggleAuthView = Notification.Name("toggleAuthView")
}

struct AuthContainerView: View {
    @Binding var isAuthenticated: Bool
    @State private var showLogin = true

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            if showLogin {
                LoginView(isAuthenticated: $isAuthenticated)
                AuthSwitchPrompt(message: "Don't have an account?", buttonText: "Sign Up") {
                    withAnimation { showLogin = false }
                }
            } else {
                CreateAccountView(isAuthenticated: $isAuthenticated)
                AuthSwitchPrompt(message: "Already have an account?", buttonText: "Sign In") {
                    withAnimation { showLogin = true }
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

struct AuthSwitchPrompt: View {
    let message: String
    let buttonText: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text(message)
                .foregroundColor(.gray)
                .font(.footnote)
            Button(action: action) {
                Text(buttonText)
                    .fontWeight(.bold)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 10)
                    .background(Color.green) 
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }

        }
    }
}
