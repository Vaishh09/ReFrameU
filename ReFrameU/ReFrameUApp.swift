//
//  ReFrameUApp.swift
//  ReFrameU
//
//  Created by Vaishnavi Mahajan on 4/3/25.
//

// ReFrameUApp.swift

import SwiftUI

@main
struct ReFrameUApp: App {
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}

// MARK: - Authentication Flow

struct AuthView: View {
    @State private var isAuthenticated = false

    var body: some View {
        if isAuthenticated {
            ContentView()
        } else {
            WelcomeScreen(isAuthenticated: $isAuthenticated)
        }
    }
}

struct WelcomeScreen: View {
    @Binding var isAuthenticated: Bool
    @State private var showLogin = true

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to ReFrameU")
                .font(.largeTitle)
                .fontWeight(.bold)

            if showLogin {
                LoginView(isAuthenticated: $isAuthenticated)
            } else {
                CreateAccountView(isAuthenticated: $isAuthenticated)
            }

            Button(action: {
                showLogin.toggle()
            }) {
                Text(showLogin ? "Don't have an account? Sign up" : "Already have an account? Log in")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 12) {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                // Simulate login (replace with Firebase/Auth0 later)
                if !email.isEmpty && !password.isEmpty {
                    isAuthenticated = true
                }
            }) {
                Text("Log In")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct CreateAccountView: View {
    @Binding var isAuthenticated: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
        VStack(spacing: 12) {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                // Simulate account creation
                if !email.isEmpty && password == confirmPassword {
                    isAuthenticated = true
                }
            }) {
                Text("Create Account")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

// MARK: - Main App View (Tab Navigation)

struct ContentView: View {
    var body: some View {
        TabView {
            ThoughtInputView()
                .tabItem {
                    Label("Reframe", systemImage: "bubble.left.and.bubble.right")
                }

            ToolboxView()
                .tabItem {
                    Label("Toolbox", systemImage: "archivebox")
                }

            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
        .accentColor(Color("AccentColor"))
    }
}

// Placeholder Views
struct ThoughtInputView: View {
    var body: some View {
        Text("Thought Input View")
    }
}

struct ToolboxView: View {
    var body: some View {
        Text("Toolbox View")
    }
}

struct ProgressView: View {
    var body: some View {
        Text("Progress View")
    }
}
