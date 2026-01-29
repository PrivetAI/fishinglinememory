import SwiftUI

struct AppTheme {
    // Background colours
    static let background = Color(hex: "0D1B2A")
    static let cardBackground = Color(hex: "1B3A4B")
    static let cardBackgroundLight = Color(hex: "254E5C")
    
    // Primary colours - fishing blue/cyan
    static let primary = Color(hex: "48CAE4")
    static let accent = Color(hex: "90E0EF")
    static let accentLight = Color(hex: "CAF0F8")
    
    // Status colours
    static let statusGood = Color(hex: "52B788")
    static let statusGoodDark = Color(hex: "40916C")
    static let statusWarning = Color(hex: "F4A261")
    static let statusWarningDark = Color(hex: "E76F51")
    static let statusDanger = Color(hex: "E63946")
    static let statusDangerDark = Color(hex: "9D0208")
    
    // Text colours
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "A8DADC")
    static let textMuted = Color(hex: "6C8B8F")
    
    // Gradients
    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "48CAE4"), Color(hex: "0096C7")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let goodGradient = LinearGradient(
        colors: [Color(hex: "52B788"), Color(hex: "40916C")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let warningGradient = LinearGradient(
        colors: [Color(hex: "F4A261"), Color(hex: "E76F51")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let dangerGradient = LinearGradient(
        colors: [Color(hex: "E63946"), Color(hex: "9D0208")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Spacing
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let paddingExtraLarge: CGFloat = 32
    
    // Corner radius
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMedium: CGFloat = 12
    static let cornerRadiusLarge: CGFloat = 20
    
    // Shadows
    static let shadowRadius: CGFloat = 10
    static let shadowOpacity: Double = 0.3
}

// Hex colour extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
