import SwiftUI

struct ProgressBarView: View {
    let progress: Double // 0-100
    let status: LineStatus
    
    private var progressColor: Color {
        switch status {
        case .good:
            return AppTheme.statusGood
        case .consider:
            return AppTheme.statusWarning
        case .replace:
            return AppTheme.statusDanger
        }
    }
    
    private var gradient: LinearGradient {
        switch status {
        case .good:
            return AppTheme.goodGradient
        case .consider:
            return AppTheme.warningGradient
        case .replace:
            return AppTheme.dangerGradient
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 6)
                    .fill(AppTheme.background.opacity(0.5))
                    .frame(height: 12)
                
                // Progress fill
                RoundedRectangle(cornerRadius: 6)
                    .fill(gradient)
                    .frame(width: geometry.size.width * CGFloat(progress / 100), height: 12)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 12)
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ProgressBarView(progress: 80, status: .good)
            ProgressBarView(progress: 45, status: .consider)
            ProgressBarView(progress: 15, status: .replace)
        }
        .padding()
        .background(AppTheme.cardBackground)
    }
}
