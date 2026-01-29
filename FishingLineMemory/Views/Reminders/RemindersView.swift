import SwiftUI

struct RemindersView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedRod: FishingRod?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerView
                        
                        if dataManager.urgentReminders.isEmpty && dataManager.upcomingReminders.isEmpty {
                            emptyStateView
                        } else {
                            // Urgent section
                            if !dataManager.urgentReminders.isEmpty {
                                urgentSection
                            }
                            
                            // Upcoming section
                            if !dataManager.upcomingReminders.isEmpty {
                                upcomingSection
                            }
                        }
                    }
                    .adaptivePadding()
                    .padding(.vertical, 16)
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedRod) { rod in
                RodDetailView(rod: rod)
                    .environmentObject(dataManager)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var headerView: some View {
        HStack {
            Text("Reminders")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
                .frame(height: 60)
            
            ZStack {
                Circle()
                    .fill(AppTheme.statusGood.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(AppTheme.statusGood)
            }
            
            VStack(spacing: 8) {
                Text("All Good!")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("No line changes needed right now.\nKeep fishing!")
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
    
    private var urgentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle()
                    .fill(AppTheme.statusDanger)
                    .frame(width: 10, height: 10)
                
                Text("URGENT")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.statusDanger)
            }
            
            ForEach(dataManager.urgentReminders) { rod in
                ReminderCardView(rod: rod, isUrgent: true) {
                    selectedRod = rod
                } onDone: {
                    dataManager.changeLine(for: rod.id, reason: .scheduled)
                } onSnooze: {
                    dataManager.snoozeReminder(for: rod.id)
                }
            }
        }
    }
    
    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle()
                    .fill(AppTheme.statusWarning)
                    .frame(width: 10, height: 10)
                
                Text("UPCOMING")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.statusWarning)
            }
            
            ForEach(dataManager.upcomingReminders) { rod in
                ReminderCardView(rod: rod, isUrgent: false) {
                    selectedRod = rod
                } onDone: {
                    dataManager.changeLine(for: rod.id, reason: .scheduled)
                } onSnooze: {
                    dataManager.snoozeReminder(for: rod.id)
                }
            }
        }
    }
}

// MARK: - Reminder Card

struct ReminderCardView: View {
    let rod: FishingRod
    let isUrgent: Bool
    var onTap: () -> Void
    var onDone: () -> Void
    var onSnooze: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    RodIconView(iconName: rod.iconName, size: 50)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(rod.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppTheme.textPrimary)
                        
                        Text("Line age: \(rod.daysSinceChange) days")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                        
                        Text("Used: \(rod.usageCount) times")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppTheme.textMuted)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(isUrgent ? "Time to replace!" : "Consider changing soon")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isUrgent ? AppTheme.statusDanger : AppTheme.statusWarning)
            
            HStack(spacing: 12) {
                Button(action: onDone) {
                    Text("Done")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(AppTheme.primaryGradient)
                        .cornerRadius(AppTheme.cornerRadiusSmall)
                }
                
                Button(action: onSnooze) {
                    Text("Snooze")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(AppTheme.cardBackgroundLight)
                        .cornerRadius(AppTheme.cornerRadiusSmall)
                }
            }
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusMedium)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusMedium)
                .stroke(isUrgent ? AppTheme.statusDanger.opacity(0.5) : AppTheme.statusWarning.opacity(0.3), lineWidth: 1)
        )
    }
}

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
            .environmentObject(DataManager())
    }
}
