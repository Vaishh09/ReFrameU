import SwiftUI

// MARK: - MAIN TAB VIEW

struct MainTabView: View {
    @State private var selectedTab: Tab = .reframe
    @State private var showMenu = false
    @State private var activeNav: NavigationDestination?

    enum Tab {
        case reframe, toolbox, progress, island
    }

    enum NavigationDestination: Hashable {
        case settings, profile, journal
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    switch selectedTab {
                    case .reframe:
                        ThoughtInputView()
                    case .toolbox:
                        ToolboxView()
                    case .progress:
                        MoodProgressView()
                    case .island:
                        IslandView()
                    }
                }

                VStack {
                    Spacer()
                    ZStack {
                        HStack {
                            tabButton(tab: .reframe, label: "Reframe", icon: "bubble.left.and.bubble.right")
                            tabButton(tab: .toolbox, label: "Toolbox", icon: "archivebox")
                            Spacer().frame(width: 100)
                            tabButton(tab: .progress, label: "Progress", icon: "chart.line.uptrend.xyaxis")
                            tabButton(tab: .island, label: "Island", icon: "tree")
                        }
                        .padding(.horizontal, 24)
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .shadow(radius: 4)

                        Button(action: {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.blue)
                                .background(Circle().fill(Color(.systemBackground)))
                                .shadow(radius: 4)
                        }

                        if showMenu {
                            VStack(spacing: 12) {
                                Button {
                                    activeNav = .settings
                                    showMenu = false
                                } label: {
                                    Label("Settings", systemImage: "gearshape")
                                }

                                Button {
                                    activeNav = .profile
                                    showMenu = false
                                } label: {
                                    Label("Profile", systemImage: "person.crop.circle")
                                }

                                Button {
                                    activeNav = .journal
                                    showMenu = false
                                } label: {
                                    Label("Journal", systemImage: "pencil.and.ellipsis.rectangle")
                                }

                            }
                            .font(.headline)
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(14)
                            .shadow(radius: 6)
                            .offset(y: -100)
                            .transition(.scale)
                        }
                    }
                    .padding(10)
                }

                NavigationLink(
                    destination: destinationView(for: activeNav),
                    isActive: Binding(
                        get: { activeNav != nil },
                        set: { if !$0 { activeNav = nil } }
                    )
                ) {
                    EmptyView()
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }

    @ViewBuilder
    func destinationView(for nav: NavigationDestination?) -> some View {
        switch nav {
        case .settings: SettingsView()
        case .profile: ProfileView()
        case .journal: JournalView()
        case .none: EmptyView()
        }
    }

    func tabButton(tab: Tab, label: String, icon: String) -> some View {
        Button {
            selectedTab = tab
            showMenu = false
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                Text(label)
                    .font(.caption2)
            }
            .foregroundColor(selectedTab == tab ? .blue : .gray)
        }
        .accentColor(Color.blue)
    }
}

#Preview {
    MainTabView()
}
