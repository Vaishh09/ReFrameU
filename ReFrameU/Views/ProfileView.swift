import SwiftUI
import FirebaseAuth
import PhotosUI

struct ProfileView: View {
    @State private var fullName: String = "Reframe Explorer"
    @State private var email: String = Auth.auth().currentUser?.email ?? "user@reframeu.app"
    @State private var streak: Int = 5
    @State private var profileImage: Image? = nil
    @State private var selectedPhoto: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.green.opacity(0.15), .blue.opacity(0.1)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("👤 My Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    ZStack {
                        if let profileImage = profileImage {
                            profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 110, height: 110)
                                .overlay(Text("📷").font(.largeTitle))
                        }
                    }

                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Text("Upload Profile Picture")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .onChange(of: selectedPhoto) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                profileImage = Image(uiImage: uiImage)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Full Name: \(fullName)", systemImage: "person.fill")
                        Label("Email: \(email)", systemImage: "envelope.fill")
                        Label("Current Streak: \(streak) days", systemImage: "flame.fill")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(14)
                    .shadow(radius: 3)

                    Button {
                        print("🧑‍🤝‍🧑 Add a friend tapped")
                    } label: {
                        Label("Add a Friend", systemImage: "person.crop.circle.badge.plus")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }
}
