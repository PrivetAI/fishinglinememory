import SwiftUI

struct TripHistoryView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddTrip = false
    
    private var sortedTrips: [FishingTrip] {
        dataManager.trips.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        headerView
                        
                        if sortedTrips.isEmpty {
                            emptyStateView
                        } else {
                            tripsListView
                        }
                    }
                    .adaptivePadding()
                    .padding(.vertical, 16)
                }
            }
            .navigationBarHidden(true)
            .adaptiveSheet(isPresented: $showingAddTrip) {
                AddTripView()
                    .environmentObject(dataManager)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Fishing Trips")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                
                if !sortedTrips.isEmpty {
                    Text("\(sortedTrips.count) trip\(sortedTrips.count == 1 ? "" : "s") logged")
                        .font(.system(size: 15))
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            
            Spacer()
            
            Button(action: { showingAddTrip = true }) {
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
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
                .frame(height: 60)
            
            ZStack {
                Circle()
                    .fill(AppTheme.cardBackground)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "figure.fishing")
                    .font(.system(size: 40))
                    .foregroundColor(AppTheme.primary)
            }
            
            VStack(spacing: 8) {
                Text("No Trips Yet")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Log your fishing trips to track\nline usage automatically")
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            CustomButtonView(title: "Log First Trip", icon: "plus", style: .primary) {
                showingAddTrip = true
            }
            .frame(maxWidth: 280)
            
            Spacer()
        }
    }
    
    private var tripsListView: some View {
        VStack(spacing: 12) {
            ForEach(sortedTrips) { trip in
                TripCardView(trip: trip, rods: rodsForTrip(trip))
            }
        }
    }
    
    private func rodsForTrip(_ trip: FishingTrip) -> [FishingRod] {
        trip.rodIds.compactMap { rodId in
            dataManager.rods.first { $0.id == rodId }
        }
    }
}

// MARK: - Trip Card

struct TripCardView: View {
    let trip: FishingTrip
    let rods: [FishingRod]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date and fish count
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trip.date.formatted())
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text(trip.date.daysAgo())
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.textMuted)
                }
                
                Spacer()
                
                if trip.fishCaught > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "fish.fill")
                            .font(.system(size: 14))
                        Text("\(trip.fishCaught)")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(AppTheme.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppTheme.primary.opacity(0.2))
                    .cornerRadius(AppTheme.cornerRadiusSmall)
                }
            }
            
            // Rods used
            if !rods.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Rods used:")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textMuted)
                    
                    HStack(spacing: 8) {
                        ForEach(rods) { rod in
                            HStack(spacing: 6) {
                                RodIconView(iconName: rod.iconName, size: 24)
                                Text(rod.name)
                                    .font(.system(size: 13))
                                    .foregroundColor(AppTheme.textSecondary)
                                    .lineLimit(1)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppTheme.cardBackgroundLight)
                            .cornerRadius(AppTheme.cornerRadiusSmall)
                        }
                    }
                }
            }
            
            // Notes
            if let notes = trip.notes, !notes.isEmpty {
                Text(notes)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.background.opacity(0.5))
                    .cornerRadius(AppTheme.cornerRadiusSmall)
            }
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
}

struct TripHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        TripHistoryView()
            .environmentObject(DataManager())
    }
}
