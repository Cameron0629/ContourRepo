import SwiftUI

struct MainTabView: View {
    @Binding var isLoggedIn: Bool
    @State private var selectedTab: Tab = .dashboard

    enum Tab: String, CaseIterable {
        case profile = "Profile"
        case dashboard = "Dashboard"
        case settings = "Settings"
        case wardrobe = "Wardrobe"
        case browseClothing = "Browse"

        var iconName: String {
            switch self {
            
            case .dashboard: return "house.fill"
            case .browseClothing: return "tshirt.fill"
            case .wardrobe: return "hanger"
            case .profile: return "person.crop.circle"
            case .settings: return "gear"
            
            }
        }
        
        @ViewBuilder
        var view: some View {
            NavigationStack {
                switch self {
                case .dashboard: DashboardView()
                case .wardrobe: WardrobeView()
                case .browseClothing: BrowseClothingView()
                case .profile: ProfileView()
                case .settings: SettingsView()
                }
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tab.view
                    .tag(tab)
                    .tabItem {
                        Label(tab.rawValue, systemImage: tab.iconName)
                    }
            }
        }
        .tint(.contourPurple)
    }
}

#Preview {
    MainTabView(isLoggedIn: .constant(true))
}
