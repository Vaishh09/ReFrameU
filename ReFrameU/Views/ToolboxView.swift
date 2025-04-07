import SwiftUI

// MARK: - TOOLBOX VIEW

struct ToolboxView: View {
    @State private var firestoreReframes: [String] = []
    @State private var searchText = ""
    @State private var pinnedReframe: String? = nil

    var filteredReframes: [String] {
        if searchText.isEmpty { return firestoreReframes }
        return firestoreReframes.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.yellow.opacity(0.2), Color.orange.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea()

                VStack(alignment: .leading, spacing: 10) {
                    Text("🌼 Your Saved Reframes")
                        .font(.title2)
                        .bold()

                    TextField("Search reframes...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 6)

                    if let pinned = pinnedReframe {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("📌 Pinned")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("🌟 \(pinned)")
                                .padding()
                                .background(Color.yellow.opacity(0.3))
                                .cornerRadius(10)
                        }
                    }

                    if filteredReframes.isEmpty {
                        Text("You haven’t saved any reframes yet.")
                            .foregroundColor(.gray)
                            .padding(.top)
                    } else {
                        List {
                            ForEach(filteredReframes, id: \.self) { reframe in
                                HStack {
                                    Text("🌱 \(reframe)")
                                        .contextMenu {
                                            Button("Copy") {
                                                UIPasteboard.general.string = reframe
                                            }
                                            Button("Pin to top") {
                                                pinnedReframe = reframe
                                            }
                                            Button("Delete") {
                                                firestoreReframes.removeAll { $0 == reframe }
                                            }
                                        }
                                    Spacer()
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                }
                .padding()
                .navigationTitle("Toolbox")
                .onAppear {
                    FirestoreManager.shared.fetchReframes { reframes in
                        firestoreReframes = reframes
                    }
                }
            }
        }
    }
}
