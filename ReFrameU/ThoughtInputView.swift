//
//  ThoughtInputView.swift
//  ReFrameU
//
//  Created by Vaishnavi Mahajan on 4/3/25.
//

import SwiftUI

struct ThoughtInputView: View {
    @State private var userThought = ""
    @State private var reframes: [String] = []
    @State private var isLoading = false

    @AppStorage("savedReframes") private var savedReframes: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Reflect on Your Thought")
                    .font(.title2)
                    .fontWeight(.semibold)

                TextEditor(text: $userThought)
                    .frame(height: 150)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                Button("Generate Reframes") {
                    generateReframes()
                }
                .disabled(userThought.isEmpty)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)

                if isLoading {
                    ProgressView("Reframing with care...")
                }

                ForEach(reframes.indices, id: \.self) { i in
                    HStack {
                        Text("🌱 \(reframes[i])")
                            .padding(.vertical, 6)
                        Spacer()
                        Button {
                            saveReframe(reframes[i])
                        } label: {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.horizontal)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Reframe a Thought")
        }
    }

    func generateReframes() {
        isLoading = true
        reframes = []

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            reframes = [
                "Try to look at this situation logically...",
                "There might be something positive hidden in this...",
                "Be kind to yourself. You’re doing your best."
            ]
            isLoading = false
        }
    }

    func saveReframe(_ text: String) {
        var saved = Set(savedReframes.components(separatedBy: "|").filter { !$0.isEmpty })
        saved.insert(text)
        savedReframes = saved.joined(separator: "|")
    }
}
