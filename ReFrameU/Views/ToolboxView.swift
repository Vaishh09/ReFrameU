import SwiftUI

struct ToolboxView: View {
    @State private var firestoreReframes: [String] = []

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                Text("🌼 Your Saved Reframes")
                    .font(.title3)
                    .fontWeight(.bold)

                if firestoreReframes.isEmpty {
                    Text("You haven’t saved any reframes yet.")
                        .foregroundColor(.gray)
                        .padding(.top)
                } else {
                    List {
                        ForEach(firestoreReframes, id: \.self) { reframe in
                            Text("🌱 \(reframe)")
                                .padding(.vertical, 4)
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
