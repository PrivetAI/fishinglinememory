import SwiftUI

struct RodIconView: View {
    let iconName: String
    var size: CGFloat = 60
    
    private let iconColors: [String: [Color]] = [
        "rod_1": [Color(hex: "48CAE4"), Color(hex: "0096C7")],
        "rod_2": [Color(hex: "52B788"), Color(hex: "40916C")],
        "rod_3": [Color(hex: "F4A261"), Color(hex: "E76F51")],
        "rod_4": [Color(hex: "9D4EDD"), Color(hex: "7B2CBF")],
        "rod_5": [Color(hex: "E63946"), Color(hex: "9D0208")],
        "rod_6": [Color(hex: "FFD60A"), Color(hex: "FFC300")]
    ]
    
    var body: some View {
        ZStack {
            // Background circle with gradient
            Circle()
                .fill(
                    LinearGradient(
                        colors: iconColors[iconName] ?? [AppTheme.primary, AppTheme.accent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
            
            // Rod icon illustration
            RodIllustration()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }
}

struct RodIllustration: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Rod handle
        path.move(to: CGPoint(x: width * 0.1, y: height * 0.9))
        path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.1))
        
        // Reel
        path.addEllipse(in: CGRect(
            x: width * 0.15,
            y: height * 0.65,
            width: width * 0.25,
            height: width * 0.25
        ))
        
        // Line
        path.move(to: CGPoint(x: width * 0.9, y: height * 0.1))
        path.addCurve(
            to: CGPoint(x: width * 0.95, y: height * 0.4),
            control1: CGPoint(x: width * 1.0, y: height * 0.15),
            control2: CGPoint(x: width * 1.0, y: height * 0.3)
        )
        
        return path
    }
}

struct RodIconView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 16) {
            RodIconView(iconName: "rod_1")
            RodIconView(iconName: "rod_2")
            RodIconView(iconName: "rod_3")
            RodIconView(iconName: "rod_4")
        }
        .padding()
        .background(AppTheme.background)
    }
}
