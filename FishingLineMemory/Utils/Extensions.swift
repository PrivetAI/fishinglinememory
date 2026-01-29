import Foundation
import SwiftUI

extension Date {
    func daysAgo() -> String {
        let days = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
        if days == 0 {
            return "Today"
        } else if days == 1 {
            return "Yesterday"
        } else {
            return "\(days) days ago"
        }
    }
    
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: self)
    }
}

extension Double {
    func formatDiameter() -> String {
        return String(format: "%.2fmm", self)
    }
    
    func formatStrength() -> String {
        return String(format: "%.1f lb", self)
    }
    
    func formatLength() -> String {
        return String(format: "%.0fm", self)
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
    }
    
    func adaptivePadding() -> some View {
        self.padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 16)
    }
}
