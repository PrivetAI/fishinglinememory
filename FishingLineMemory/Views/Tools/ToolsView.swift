import SwiftUI

struct ToolsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerView
                        
                        // Statistics card first
                        statisticsCard
                        
                        // Tools section
                        toolsHeader
                        toolsSection
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
            Text("Tools & Stats")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppTheme.textPrimary)
            
            Spacer()
        }
    }
    
    private var statisticsCard: some View {
        NavigationLink(destination: StatisticsView()) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "9D4EDD").opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 26))
                        .foregroundColor(Color(hex: "9D4EDD"))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Statistics")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text("View your fishing activity and line change stats")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textMuted)
            }
            .padding(16)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var toolsHeader: some View {
        HStack {
            Text("FISHING TOOLS")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
            Spacer()
        }
    }
    
    private var toolsSection: some View {
        VStack(spacing: 16) {
            // Spool Calculator
            NavigationLink(destination: SpoolCalculatorView()) {
                ToolCardView(
                    title: "Spool Calculator",
                    description: "Calculate how much line you need to fill your reel",
                    icon: "function",
                    color: AppTheme.primary
                )
            }
            
            // Knots Guide
            NavigationLink(destination: KnotsGuideView()) {
                ToolCardView(
                    title: "Knots Guide",
                    description: "Learn essential fishing knots with step-by-step instructions",
                    icon: "link.circle.fill",
                    color: AppTheme.statusGood
                )
            }
            
            // Line Comparison
            NavigationLink(destination: LineComparisonView()) {
                ToolCardView(
                    title: "Line Comparison",
                    description: "Compare different line types by their characteristics",
                    icon: "arrow.left.arrow.right.circle.fill",
                    color: AppTheme.statusWarning
                )
            }
        }
    }
}

// MARK: - Tool Card

struct ToolCardView: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 26))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textMuted)
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
}

// MARK: - Preview

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsView()
    }
}
