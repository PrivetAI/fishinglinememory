import SwiftUI

struct StatusBadgeView: View {
    let status: LineStatus
    
    private var backgroundColor: Color {
        switch status {
        case .good:
            return AppTheme.statusGood.opacity(0.2)
        case .consider:
            return AppTheme.statusWarning.opacity(0.2)
        case .replace:
            return AppTheme.statusDanger.opacity(0.2)
        }
    }
    
    private var textColor: Color {
        switch status {
        case .good:
            return AppTheme.statusGood
        case .consider:
            return AppTheme.statusWarning
        case .replace:
            return AppTheme.statusDanger
        }
    }
    
    private var iconName: String {
        switch status {
        case .good:
            return "checkmark.circle.fill"
        case .consider:
            return "exclamationmark.triangle.fill"
        case .replace:
            return "xmark.circle.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(textColor)
                .frame(width: 8, height: 8)
            
            Text(status.rawValue)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(textColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(backgroundColor)
        .cornerRadius(AppTheme.cornerRadiusSmall)
    }
}

struct StatusBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            StatusBadgeView(status: .good)
            StatusBadgeView(status: .consider)
            StatusBadgeView(status: .replace)
        }
        .padding()
        .background(AppTheme.background)
    }
}
