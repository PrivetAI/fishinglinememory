import SwiftUI

// MARK: - Line Characteristics

struct LineCharacteristics {
    let strength: Double // 1-10
    let stretch: Double // 1-10
    let visibility: Double // 1-10 (higher = more visible)
    let abrasionResistance: Double // 1-10
    let lifespan: Double // 1-10
    let memory: Double // 1-10 (higher = more memory/coiling)
    let costPerMeter: Double // relative 1-10
    let sensitivity: Double // 1-10
}

let lineCharacteristics: [LineType: LineCharacteristics] = [
    .monofilament: LineCharacteristics(
        strength: 5,
        stretch: 8,
        visibility: 6,
        abrasionResistance: 5,
        lifespan: 4,
        memory: 7,
        costPerMeter: 3,
        sensitivity: 4
    ),
    .braided: LineCharacteristics(
        strength: 10,
        stretch: 1,
        visibility: 8,
        abrasionResistance: 7,
        lifespan: 9,
        memory: 1,
        costPerMeter: 8,
        sensitivity: 10
    ),
    .fluorocarbon: LineCharacteristics(
        strength: 6,
        stretch: 4,
        visibility: 2,
        abrasionResistance: 8,
        lifespan: 6,
        memory: 6,
        costPerMeter: 9,
        sensitivity: 7
    ),
    .hybrid: LineCharacteristics(
        strength: 7,
        stretch: 5,
        visibility: 5,
        abrasionResistance: 6,
        lifespan: 5,
        memory: 5,
        costPerMeter: 6,
        sensitivity: 6
    )
]

// MARK: - Comparison Attribute

struct ComparisonAttribute: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let getValue: (LineCharacteristics) -> Double
    let description: String
    let higherIsBetter: Bool
}

let comparisonAttributes: [ComparisonAttribute] = [
    ComparisonAttribute(
        name: "Strength",
        icon: "bolt.fill",
        getValue: { $0.strength },
        description: "Breaking strength relative to diameter",
        higherIsBetter: true
    ),
    ComparisonAttribute(
        name: "Sensitivity",
        icon: "waveform",
        getValue: { $0.sensitivity },
        description: "Ability to feel bites and bottom structure",
        higherIsBetter: true
    ),
    ComparisonAttribute(
        name: "Stretch",
        icon: "arrow.left.and.right",
        getValue: { $0.stretch },
        description: "How much the line stretches under load",
        higherIsBetter: false
    ),
    ComparisonAttribute(
        name: "Invisibility",
        icon: "eye.slash",
        getValue: { 10 - $0.visibility },
        description: "How invisible the line is underwater",
        higherIsBetter: true
    ),
    ComparisonAttribute(
        name: "Abrasion Resistance",
        icon: "shield.fill",
        getValue: { $0.abrasionResistance },
        description: "Resistance to nicks and scratches",
        higherIsBetter: true
    ),
    ComparisonAttribute(
        name: "Lifespan",
        icon: "clock.fill",
        getValue: { $0.lifespan },
        description: "How long the line lasts with proper care",
        higherIsBetter: true
    ),
    ComparisonAttribute(
        name: "Low Memory",
        icon: "arrow.uturn.down.circle",
        getValue: { 10 - $0.memory },
        description: "Resistance to coiling and kinking",
        higherIsBetter: true
    ),
    ComparisonAttribute(
        name: "Value",
        icon: "dollarsign.circle",
        getValue: { 10 - $0.costPerMeter },
        description: "Cost effectiveness per meter",
        higherIsBetter: true
    )
]

// MARK: - Line Comparison View

struct LineComparisonView: View {
    @State private var selectedTypes: Set<LineType> = [.monofilament, .braided]
    
    private var selectedTypesArray: [LineType] {
        Array(selectedTypes).sorted { $0.description < $1.description }
    }
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Line type selector
                    selectorSection
                    
                    // Comparison chart
                    if selectedTypes.count >= 2 {
                        comparisonSection
                        
                        // Best for section
                        bestForSection
                    } else {
                        selectMorePrompt
                    }
                }
                .adaptivePadding()
                .padding(.vertical, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Line Comparison")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
            }
        }
    }
    
    private var selectorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Lines to Compare")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            HStack(spacing: 8) {
                ForEach(LineType.allCases, id: \.self) { type in
                    LineTypeChip(
                        type: type,
                        isSelected: selectedTypes.contains(type),
                        color: colorForLineType(type)
                    ) {
                        if selectedTypes.contains(type) {
                            selectedTypes.remove(type)
                        } else if selectedTypes.count < 3 {
                            selectedTypes.insert(type)
                        }
                    }
                }
            }
            
            Text("Select 2-3 line types")
                .font(.system(size: 12))
                .foregroundColor(AppTheme.textMuted)
        }
    }
    
    private var selectMorePrompt: some View {
        VStack(spacing: 16) {
            Image(systemName: "arrow.left.arrow.right.circle")
                .font(.system(size: 50))
                .foregroundColor(AppTheme.textMuted)
            
            Text("Select at least 2 line types to compare")
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
    
    private var comparisonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Comparison")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            // Legend
            HStack(spacing: 16) {
                ForEach(selectedTypesArray, id: \.self) { type in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(colorForLineType(type))
                            .frame(width: 10, height: 10)
                        Text(type.description)
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
            .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                ForEach(Array(comparisonAttributes.enumerated()), id: \.element.id) { index, attr in
                    if index > 0 {
                        Divider().background(AppTheme.background)
                    }
                    
                    ComparisonRow(
                        attribute: attr,
                        types: selectedTypesArray,
                        colorFor: colorForLineType
                    )
                }
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var bestForSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Best For")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            VStack(spacing: 12) {
                ForEach(selectedTypesArray, id: \.self) { type in
                    BestForCard(type: type, color: colorForLineType(type))
                }
            }
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

// MARK: - Line Type Chip

struct LineTypeChip: View {
    let type: LineType
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.shortName)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isSelected ? .white : AppTheme.textSecondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(isSelected ? color : AppTheme.cardBackground)
                .cornerRadius(8)
        }
    }
}

// MARK: - Comparison Row

struct ComparisonRow: View {
    let attribute: ComparisonAttribute
    let types: [LineType]
    let colorFor: (LineType) -> Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: attribute.icon)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.primary)
                    .frame(width: 20)
                
                Text(attribute.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
            }
            
            // Bars
            ForEach(types, id: \.self) { type in
                if let chars = lineCharacteristics[type] {
                    let value = attribute.getValue(chars)
                    
                    HStack(spacing: 8) {
                        Text(type.shortName)
                            .font(.system(size: 11))
                            .foregroundColor(AppTheme.textMuted)
                            .frame(width: 40, alignment: .leading)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(AppTheme.background.opacity(0.5))
                                
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(colorFor(type))
                                    .frame(width: geometry.size.width * CGFloat(value / 10))
                            }
                        }
                        .frame(height: 8)
                        
                        Text(String(format: "%.0f", value))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(width: 20)
                    }
                }
            }
        }
        .padding(16)
    }
}

// MARK: - Best For Card

struct BestForCard: View {
    let type: LineType
    let color: Color
    
    private var bestFor: [String] {
        switch type {
        case .monofilament:
            return ["Beginners", "Topwater fishing", "General purpose", "Float fishing"]
        case .braided:
            return ["Heavy cover fishing", "Deep water", "Long casts", "Jigging"]
        case .fluorocarbon:
            return ["Clear water", "Leader material", "Wary fish", "Bottom fishing"]
        case .hybrid:
            return ["All-around use", "Value seekers", "Moderate conditions"]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 12, height: 12)
                
                Text(type.description)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            WrappingHStack(items: bestFor, spacing: 8, color: color) { use in
                Text(use)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(color.opacity(0.15))
                    .cornerRadius(12)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardBackground)
        .cornerRadius(AppTheme.cornerRadiusMedium)
    }
}

// MARK: - Wrapping HStack (iOS 15.6 compatible)

struct WrappingHStack<Content: View>: View {
    let items: [String]
    let spacing: CGFloat
    let color: Color
    let content: (String) -> Content
    
    init(items: [String], spacing: CGFloat = 8, color: Color, @ViewBuilder content: @escaping (String) -> Content) {
        self.items = items
        self.spacing = spacing
        self.color = color
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(Array(items.chunked(into: 2).enumerated()), id: \.offset) { _, row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { item in
                        content(item)
                    }
                }
            }
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

// MARK: - LineType Extension

extension LineType {
    var shortName: String {
        switch self {
        case .monofilament: return "Mono"
        case .braided: return "Braid"
        case .fluorocarbon: return "Fluoro"
        case .hybrid: return "Hybrid"
        }
    }
}

// MARK: - Preview

struct LineComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LineComparisonView()
        }
    }
}
