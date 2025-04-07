import SwiftUI

struct GardenBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.yellow.opacity(0.8))
                .frame(width: 80, height: 80)
                .offset(x: 120, y: -280)

            RoundedRectangle(cornerRadius: 200)
                .fill(Color.green.opacity(0.3))
                .frame(height: 250)
                .offset(y: 220)

            RoundedRectangle(cornerRadius: 300)
                .fill(Color.green.opacity(0.2))
                .frame(height: 300)
                .offset(y: 260)
        }
    }
}
