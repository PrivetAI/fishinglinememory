import SwiftUI

struct CustomButtonView: View {
    let title: String
    var icon: String? = nil
    var style: ButtonStyle = .primary
    let action: () -> Void
    
    enum ButtonStyle {
        case primary
        case secondary
        case danger
    }
    
    private var backgroundColor: LinearGradient {
        switch style {
        case .primary:
            return AppTheme.primaryGradient
        case .secondary:
            return LinearGradient(
                colors: [AppTheme.cardBackgroundLight, AppTheme.cardBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .danger:
            return AppTheme.dangerGradient
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .danger:
            return .white
        case .secondary:
            return AppTheme.textPrimary
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(backgroundColor)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
}

struct CustomButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            CustomButtonView(title: "Primary Button", icon: "plus", style: .primary) {}
            CustomButtonView(title: "Secondary Button", style: .secondary) {}
            CustomButtonView(title: "Danger Button", icon: "trash", style: .danger) {}
        }
        .padding()
        .background(AppTheme.background)
    }
}
