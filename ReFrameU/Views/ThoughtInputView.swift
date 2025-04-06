//
//  ThoughtInputView.swift
//  ReFrameU
//
//  Created by Vaishnavi Mahajan on 4/3/25.
//

import SwiftUI

struct ThoughtRequest: Codable {
    let userThought: String
}

struct ReframeResponse: Codable {
    let logical: String
    let optimistic: String
    let compassionate: String
}

struct ThoughtInputView: View {
    @State private var userThought = ""
    @State private var reframes: [String] = []
    @State private var isLoading = false
    @State private var selectedReframe: String? = nil
    @State private var showPopup: Bool = false

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

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(reframes, id: \.self) { reframe in
                            Button(action: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    selectedReframe = reframe
                                    showPopup = true
                                }
                            }) {
                                HStack(alignment: .top) {
                                    Text(reframe)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.leading)

                                    Spacer()

                                    Button(action: {
                                        saveReframe(reframe)
                                    }) {
                                        Image(systemName: "tray.and.arrow.down.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 1.0, green: 0.95, blue: 0.75)) // butter yellow
                                .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Reframe a Thought")
            .sheet(isPresented: $showPopup) {
                ReframePopup(reframe: selectedReframe ?? "", saveAction: saveReframe)
            }
        }
    }

    func generateReframes() {
        isLoading = true
        reframes = []

        ChatbotAPI.shared.sendToReffie(userThought) { responseText in
            isLoading = false

            guard let responseText = responseText else {
                print("No response from Reffie")
                return
            }

            let lines = responseText.components(separatedBy: "\n")
            let parsed = lines.compactMap { line -> String? in
                if line.lowercased().starts(with: "logical:") ||
                   line.lowercased().starts(with: "optimistic:") ||
                   line.lowercased().starts(with: "compassionate:") {
                    return line.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                return nil
            }

            DispatchQueue.main.async {
                reframes = parsed
            }
        }
    }

    func saveReframe(_ text: String) {
        var saved = Set(savedReframes.components(separatedBy: "|").filter { !$0.isEmpty })
        saved.insert(text)
        savedReframes = saved.joined(separator: "|")
    }

    func labelFrom(_ reframe: String) -> String {
        return reframe.components(separatedBy: ":").first ?? "Reframe"
    }

    func bodyFrom(_ reframe: String) -> String {
        return reframe.components(separatedBy: ":").dropFirst().joined(separator: ":").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct ReframePopup: View {
    let reframe: String
    let saveAction: (String) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let parts = reframe.split(separator: ":", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let title = parts.first ?? "Reframe"
        let body = parts.count > 1 ? parts[1] : "No content available."

        return VStack(spacing: 20) {
            Text(title)
                .font(.headline)

            ScrollView {
                Text(body)
                    .multilineTextAlignment(.leading)
                    .padding()
            }

            HStack(spacing: 16) {
                Button(action: {
                    saveAction(reframe)
                    dismiss()
                }) {
                    Image(systemName: "tray.and.arrow.down.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }

                Button("Close") {
                    dismiss()
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    ThoughtInputView()
}
