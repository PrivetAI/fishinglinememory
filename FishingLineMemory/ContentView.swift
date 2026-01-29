import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RodListView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet.rectangle")
                        Text("Rods")
                    }
                }
                .tag(0)
            
            TripHistoryView()
                .tabItem {
                    VStack {
                        Image(systemName: "figure.fishing")
                        Text("Trips")
                    }
                }
                .tag(1)
            
            RemindersView()
                .tabItem {
                    VStack {
                        Image(systemName: "bell")
                        Text("Alerts")
                    }
                }
                .tag(2)
            
            StatisticsView()
                .tabItem {
                    VStack {
                        Image(systemName: "chart.bar")
                        Text("Stats")
                    }
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                }
                .tag(4)
        }
        .accentColor(AppTheme.primary)
        .environmentObject(dataManager)
        .onAppear {
            configureTabBarAppearance()
        }
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppTheme.cardBackground)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppTheme.textMuted)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.textMuted)]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppTheme.primary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppTheme.primary)]
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
