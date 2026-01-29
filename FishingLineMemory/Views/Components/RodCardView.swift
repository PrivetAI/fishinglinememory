import SwiftUI

struct RodCardView: View {
    let rod: FishingRod
    var onTap: () -> Void = {}
    var onChangeLine: () -> Void = {}
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Rod icon
                RodIconView(iconName: rod.iconName, size: 56)
                
                // Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(rod.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text("\(rod.lineType.description) \(rod.lineDiameter.formatDiameter())")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.textSecondary)
                    
                    HStack(spacing: 16) {
                        Label("\(rod.daysSinceChange)d", systemImage: "calendar")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textMuted)
                        
                        Label("\(rod.usageCount) trips", systemImage: "figure.fishing")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textMuted)
                    }
                    
                    HStack(spacing: 12) {
                        ProgressBarView(progress: rod.healthPercentage, status: rod.status)
                        
                        Text("\(Int(rod.healthPercentage))%")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(width: 36)
                    }
                    
                    StatusBadgeView(status: rod.status)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.textMuted)
            }
            .padding(16)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RodCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            RodCardView(rod: FishingRod(
                name: "Winter Rod #1",
                lineType: .monofilament,
                lineDiameter: 0.14,
                lastChangeDate: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
                usageCount: 8
            ))
            
            RodCardView(rod: FishingRod(
                name: "Tip-Up Rod",
                iconName: "rod_2",
                lineType: .braided,
                lineDiameter: 0.10,
                lastChangeDate: Calendar.current.date(byAdding: .day, value: -45, to: Date())!,
                usageCount: 18
            ))
        }
        .padding()
        .background(AppTheme.background)
    }
}
