import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct IslandView: View {
    @State private var plants: [String] = []
    @State private var positions: [CGPoint] = []

    let islandSize: CGFloat = 300
    let islandRadius: CGFloat = 140
    let minDistanceBetweenPlants: CGFloat = 40

    var body: some View {
        ZStack {
            LinearGradient(colors: [.green.opacity(0.2), .blue.opacity(0.2)],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("🏝️ Your Reframe Island")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                ZStack {
                    Circle()
                        .fill(Color(red: 1.0, green: 0.95, blue: 0.8)) 
                        .frame(width: islandSize, height: islandSize)
                        .shadow(radius: 8)

                    ForEach(plants.indices, id: \.self) { index in
                        let point = positions[index]
                        Text(plants[index])
                            .font(.system(size: 36))
                            .position(point)
                    }
                }
                .frame(width: islandSize, height: islandSize)

                if plants.isEmpty {
                    Text("No plants yet. Start reframing! 🌱")
                        .foregroundColor(.gray)
                } else {
                    Text("🌿 You’ve grown \(plants.count) plants!")
                        .font(.headline)
                        .padding(.top, 8)
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            loadIslandPlants()
        }
    }

    func loadIslandPlants() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore()
            .collection("reframeIsland")
            .document(userId)
            .collection("plants")
            .order(by: "timestamp")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Failed to fetch island plants:", error.localizedDescription)
                    return
                }

                let fetchedPlants = snapshot?.documents.compactMap { $0["type"] as? String } ?? []
                self.plants = fetchedPlants
                self.positions = generateNonOverlappingPositions(count: fetchedPlants.count, radius: islandRadius)
            }
    }

    func generateNonOverlappingPositions(count: Int, radius: CGFloat) -> [CGPoint] {
        var placed: [CGPoint] = []
        let center = CGPoint(x: islandSize / 2, y: islandSize / 2)

        for _ in 0..<count {
            var point: CGPoint
            var attempts = 0
            repeat {
                let angle = Double.random(in: 0..<360) * .pi / 180
                let r = CGFloat.random(in: 20...(radius - 20))
                let x = center.x + r * CGFloat(cos(angle))
                let y = center.y + r * CGFloat(sin(angle))
                point = CGPoint(x: x, y: y)
                attempts += 1
            } while (placed.contains(where: { distance($0, point) < minDistanceBetweenPlants }) && attempts < 100)

            placed.append(point)
        }

        return placed
    }

    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2))
    }
}
