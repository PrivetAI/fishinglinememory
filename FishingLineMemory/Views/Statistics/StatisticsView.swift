import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerView
                        
                        if dataManager.rods.isEmpty {
                            emptyStateView
                        } else {
                            // Summary cards
                            summarySection
                            
                            // Line type distribution
                            distributionSection
                            
                            // Usage chart
                            usageSection
                            
                            // Insights
                            insightsSection
                        }
                    }
                    .adaptivePadding()
                    .padding(.vertical, 16)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 60)
            
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 50))
                .foregroundColor(AppTheme.textMuted)
            
            Text("No data yet")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
            
            Text("Add some rods to see statistics")
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textMuted)
            
            Spacer()
        }
    }
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(title: "Total Rods", value: "\(dataManager.totalRods)", icon: "figure.fishing")
                StatCard(title: "Avg Line Age", value: "\(dataManager.averageLineAge)d", icon: "calendar")
                StatCard(title: "Avg Usage", value: "\(dataManager.averageUsage)", icon: "repeat")
                StatCard(title: "Total Changes", value: "\(dataManager.totalLineChanges)", icon: "arrow.triangle.2.circlepath")
            }
        }
    }
    
    private var distributionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Line Types")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            VStack(spacing: 0) {
                ForEach(Array(dataManager.lineTypeDistribution.enumerated()), id: \.offset) { index, item in
                    if index > 0 {
                        Divider().background(AppTheme.background)
                    }
                    
                    HStack {
                        Circle()
                            .fill(colorForLineType(item.0))
                            .frame(width: 12, height: 12)
                        
                        Text(item.0.description)
                            .font(.system(size: 15))
                            .foregroundColor(AppTheme.textPrimary)
                        
                        Spacer()
                        
                        Text("\(item.1)")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(AppTheme.textSecondary)
                        
                        // Percentage bar
                        let percentage = Double(item.1) / Double(dataManager.totalRods) * 100
                        Text("\(Int(percentage))%")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textMuted)
                            .frame(width: 40)
                    }
                    .padding(16)
                }
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var usageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Usage by Rod")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            VStack(spacing: 12) {
                let maxUsage = dataManager.rods.map { $0.usageCount }.max() ?? 1
                
                ForEach(dataManager.rods.sorted { $0.usageCount > $1.usageCount }.prefix(5)) { rod in
                    HStack(spacing: 12) {
                        Text(rod.name)
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.textPrimary)
                            .frame(width: 100, alignment: .leading)
                            .lineLimit(1)
                        
                        GeometryReader { geometry in
                            let barWidth = geometry.size.width * CGFloat(rod.usageCount) / CGFloat(max(1, maxUsage))
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppTheme.background.opacity(0.5))
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppTheme.primaryGradient)
                                    .frame(width: max(4, barWidth))
                            }
                        }
                        .frame(height: 20)
                        
                        Text("\(rod.usageCount)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(width: 30)
                    }
                }
            }
            .padding(16)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Insights")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            VStack(spacing: 12) {
                if let oldest = dataManager.oldestLine {
                    InsightRow(
                        icon: "clock.arrow.circlepath",
                        text: "Oldest line: \(oldest.name) (\(oldest.daysSinceChange) days)"
                    )
                }
                
                if let mostUsed = dataManager.mostUsedRod {
                    InsightRow(
                        icon: "star.fill",
                        text: "Most used: \(mostUsed.name) (\(mostUsed.usageCount) trips)"
                    )
                }
                
                if dataManager.totalLineChanges > 0 {
                    let avgDays = dataManager.rods.flatMap { $0.changeHistory }.reduce(0) { $0 + $1.daysUsed } / max(1, dataManager.totalLineChanges)
                    InsightRow(
                        icon: "chart.line.uptrend.xyaxis",
                        text: "You replace line every \(avgDays) days on average"
                    )
                }
            }
            .padding(16)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private func colorForLineType(_ type: LineType) -> Color {
        switch type {
        case .monofilament:
            return AppTheme.primary
        case .braided:
            return AppTheme.statusGood
        case .fluorocarbon:
            return AppTheme.statusWarning
        case .hybrid:
            return Color(hex: "9D4EDD")
        }
    }
}

// MARK: - Components

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppTheme.primary)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
}

struct InsightRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.primary)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
            
            Spacer()
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environmentObject(DataManager())
    }
}
