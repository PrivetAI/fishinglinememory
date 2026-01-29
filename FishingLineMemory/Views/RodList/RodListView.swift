import SwiftUI

struct RodListView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddRod = false
    @State private var selectedRod: FishingRod?
    @State private var sortOption: SortOption = .status
    
    enum SortOption: String, CaseIterable {
        case status = "Status"
        case name = "Name"
        case date = "Date Changed"
    }
    
    private var sortedRods: [FishingRod] {
        switch sortOption {
        case .status:
            return dataManager.sortedRodsByStatus
        case .name:
            return dataManager.rods.sorted { $0.name < $1.name }
        case .date:
            return dataManager.rods.sorted { $0.lastChangeDate > $1.lastChangeDate }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        headerView
                        
                        // Empty state or list
                        if dataManager.rods.isEmpty {
                            emptyStateView
                        } else {
                            rodsListView
                        }
                    }
                    .adaptivePadding()
                    .padding(.vertical, 16)
                }
            }
        .navigationBarHidden(true)
            .adaptiveSheet(isPresented: $showingAddRod) {
                AddRodView()
                    .environmentObject(dataManager)
            }
            .adaptiveSheet(item: $selectedRod) { rod in
                RodDetailView(rod: rod)
                    .environmentObject(dataManager)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Fishing Rods")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    if !dataManager.rods.isEmpty {
                        Text("\(dataManager.rods.count) rod\(dataManager.rods.count == 1 ? "" : "s")")
                            .font(.system(size: 15))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
                
                Spacer()
                
                Button(action: { showingAddRod = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Add")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(AppTheme.primaryGradient)
                    .cornerRadius(AppTheme.cornerRadiusMedium)
                }
            }
            
            // Sort picker
            if !dataManager.rods.isEmpty {
                HStack {
                    Text("Sort by:")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textMuted)
                    
                    Picker("Sort", selection: $sortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
                .frame(height: 60)
            
            ZStack {
                Circle()
                    .fill(AppTheme.cardBackground)
                    .frame(width: 120, height: 120)
                
                RodIllustration()
                    .stroke(AppTheme.primary, lineWidth: 3)
                    .frame(width: 50, height: 50)
            }
            
            VStack(spacing: 8) {
                Text("No Rods Yet")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Add your first fishing rod to start\ntracking line condition")
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            CustomButtonView(title: "Add Your First Rod", icon: "plus", style: .primary) {
                showingAddRod = true
            }
            .frame(maxWidth: 280)
            
            Spacer()
        }
    }
    
    private var rodsListView: some View {
        VStack(spacing: 12) {
            ForEach(sortedRods) { rod in
                RodCardView(rod: rod) {
                    selectedRod = rod
                }
            }
        }
    }
}

struct RodListView_Previews: PreviewProvider {
    static var previews: some View {
        RodListView()
            .environmentObject(DataManager())
    }
}
