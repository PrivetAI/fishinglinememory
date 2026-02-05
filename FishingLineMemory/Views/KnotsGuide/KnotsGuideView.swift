import SwiftUI

// MARK: - Knot Model

struct FishingKnot: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let difficulty: KnotDifficulty
    let strength: Int // percentage 0-100
    let lineTypes: [LineType]
    let useCase: String
    let steps: [String]
    let tips: String
}

enum KnotDifficulty: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var color: Color {
        switch self {
        case .easy: return AppTheme.statusGood
        case .medium: return AppTheme.statusWarning
        case .hard: return AppTheme.statusDanger
        }
    }
}

// MARK: - Knots Data

let fishingKnots: [FishingKnot] = [
    FishingKnot(
        name: "Palomar Knot",
        icon: "link.circle.fill",
        difficulty: .easy,
        strength: 95,
        lineTypes: [.monofilament, .braided, .fluorocarbon],
        useCase: "Attaching hooks, lures, and swivels. One of the strongest and most reliable knots.",
        steps: [
            "Double about 15cm of line and pass the loop through the hook eye",
            "Tie a simple overhand knot with the doubled line, leaving the hook hanging loose",
            "Pass the hook through the loop",
            "Pull both ends of the line to tighten",
            "Trim the excess tag end"
        ],
        tips: "Works best with braided line. Make sure the loop passes completely over the hook before tightening."
    ),
    FishingKnot(
        name: "Improved Clinch Knot",
        icon: "arrow.triangle.2.circlepath.circle.fill",
        difficulty: .easy,
        strength: 85,
        lineTypes: [.monofilament, .fluorocarbon],
        useCase: "Tying line to hooks, lures, and swivels. Classic and time-tested knot.",
        steps: [
            "Thread the line through the hook eye and pull about 15cm through",
            "Wrap the tag end around the standing line 5-7 times",
            "Thread the tag end through the small loop near the hook eye",
            "Thread the tag end through the big loop you just created",
            "Moisten and pull tight, trim excess"
        ],
        tips: "Not recommended for braided line as it tends to slip. More wraps for thinner line."
    ),
    FishingKnot(
        name: "Uni Knot",
        icon: "circle.circle.fill",
        difficulty: .easy,
        strength: 90,
        lineTypes: [.monofilament, .braided, .fluorocarbon],
        useCase: "Versatile knot for terminal tackle, joining lines, and creating loops.",
        steps: [
            "Run the line through the hook eye and double back parallel",
            "Lay the tag end over the doubled line, creating a loop",
            "Make 5-6 wraps through the loop around both lines",
            "Moisten and pull the tag end to tighten wraps",
            "Slide the knot down to the hook eye and trim"
        ],
        tips: "Can be used as a loop knot by not sliding all the way down. Very versatile."
    ),
    FishingKnot(
        name: "Blood Knot",
        icon: "arrow.left.arrow.right.circle.fill",
        difficulty: .medium,
        strength: 85,
        lineTypes: [.monofilament, .fluorocarbon],
        useCase: "Joining two lines of similar diameter. Perfect for building leaders.",
        steps: [
            "Overlap the ends of the two lines to be joined",
            "Twist one line around the other 5-7 times",
            "Bring the tag end back and thread between the lines at the twist point",
            "Repeat with the other line, wrapping in opposite direction",
            "Thread through the center gap in opposite direction, moisten and pull tight"
        ],
        tips: "Lines should be similar diameter (within 0.05mm). Pull both standing lines to seat properly."
    ),
    FishingKnot(
        name: "Albright Knot",
        icon: "link.badge.plus",
        difficulty: .medium,
        strength: 80,
        lineTypes: [.monofilament, .braided, .fluorocarbon],
        useCase: "Joining lines of different diameters or materials. Braid to fluorocarbon leader.",
        steps: [
            "Make a loop in the heavier line and pinch it",
            "Pass the lighter line through the loop from behind",
            "Wrap the lighter line back toward the loop end 10-12 times",
            "Pass the tag end back through the loop (same side as entry)",
            "Pull the standing part of the lighter line while sliding wraps tight"
        ],
        tips: "Essential knot for connecting braided mainline to mono/fluoro leader. Keep wraps neat."
    ),
    FishingKnot(
        name: "FG Knot",
        icon: "bolt.circle.fill",
        difficulty: .hard,
        strength: 98,
        lineTypes: [.braided],
        useCase: "Strongest braid-to-leader connection. Slim profile passes through guides easily.",
        steps: [
            "Create tension in the leader line (use teeth or rod tip)",
            "Wrap braid over and under the leader alternately (weaving pattern)",
            "Make 15-20 alternating wraps",
            "Secure with half hitches alternating sides (6-10 total)",
            "Finish with 2-3 half hitches on the braid only, trim close"
        ],
        tips: "Requires practice but worth learning. The slimmest and strongest braid-to-leader knot."
    ),
    FishingKnot(
        name: "Double Uni Knot",
        icon: "arrow.triangle.merge",
        difficulty: .medium,
        strength: 90,
        lineTypes: [.monofilament, .braided, .fluorocarbon],
        useCase: "Joining two lines together. Simpler alternative to Blood Knot.",
        steps: [
            "Overlap the ends of the two lines by about 15cm",
            "Tie a Uni knot with one line around the other (4-5 wraps)",
            "Repeat with the second line around the first",
            "Moisten and pull standing lines to bring knots together",
            "Trim both tag ends close"
        ],
        tips: "Easier than Blood Knot and works well with different diameter lines."
    ),
    FishingKnot(
        name: "Snell Knot",
        icon: "arrow.down.to.line.circle.fill",
        difficulty: .medium,
        strength: 95,
        lineTypes: [.monofilament, .fluorocarbon],
        useCase: "Attaching line to hooks. Provides straight-pull hooksets.",
        steps: [
            "Thread line through hook eye toward the point",
            "Form a loop and hold it against the hook shank",
            "Wrap the tag end around the shank and through the loop 5-7 times",
            "Working toward the hook bend with each wrap",
            "Hold wraps and pull standing line to tighten, adjust if needed"
        ],
        tips: "Excellent for live bait fishing. Hook sits at perfect angle for solid hookups."
    )
]

// MARK: - Knots Guide View

struct KnotsGuideView: View {
    @State private var selectedKnot: FishingKnot?
    @State private var filterDifficulty: KnotDifficulty?
    
    private var filteredKnots: [FishingKnot] {
        if let difficulty = filterDifficulty {
            return fishingKnots.filter { $0.difficulty == difficulty }
        }
        return fishingKnots
    }
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    // Filter
                    filterSection
                    
                    // Knots list
                    ForEach(filteredKnots) { knot in
                        KnotCardView(knot: knot) {
                            selectedKnot = knot
                        }
                    }
                }
                .adaptivePadding()
                .padding(.vertical, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Knots Guide")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
            }
        }
        .sheet(item: $selectedKnot) { knot in
            KnotDetailView(knot: knot)
        }
    }
    
    private var filterSection: some View {
        HStack(spacing: 8) {
            FilterChip(title: "All", isSelected: filterDifficulty == nil) {
                filterDifficulty = nil
            }
            FilterChip(title: "Easy", isSelected: filterDifficulty == .easy, color: KnotDifficulty.easy.color) {
                filterDifficulty = .easy
            }
            FilterChip(title: "Medium", isSelected: filterDifficulty == .medium, color: KnotDifficulty.medium.color) {
                filterDifficulty = .medium
            }
            FilterChip(title: "Hard", isSelected: filterDifficulty == .hard, color: KnotDifficulty.hard.color) {
                filterDifficulty = .hard
            }
            Spacer()
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var color: Color = AppTheme.primary
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(isSelected ? .white : AppTheme.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? color : AppTheme.cardBackground)
                .cornerRadius(16)
        }
    }
}

// MARK: - Knot Card

struct KnotCardView: View {
    let knot: FishingKnot
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(AppTheme.primary.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: knot.icon)
                        .font(.system(size: 22))
                        .foregroundColor(AppTheme.primary)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(knot.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    HStack(spacing: 8) {
                        // Difficulty badge
                        Text(knot.difficulty.rawValue)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(knot.difficulty.color)
                            .cornerRadius(4)
                        
                        // Strength
                        Text("\(knot.strength)% strength")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.textMuted)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(AppTheme.textMuted)
            }
            .padding(16)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
}

// MARK: - Knot Detail View

struct KnotDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let knot: FishingKnot
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        headerSection
                        
                        // Use case
                        useCaseSection
                        
                        // Compatible line types
                        lineTypesSection
                        
                        // Steps
                        stepsSection
                        
                        // Tips
                        tipsSection
                    }
                    .adaptivePadding()
                    .padding(.vertical, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppTheme.primary)
                }
            }
        }
    }
    
    private var headerSection: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppTheme.primary.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                Image(systemName: knot.icon)
                    .font(.system(size: 32))
                    .foregroundColor(AppTheme.primary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(knot.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text(knot.difficulty.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(knot.difficulty.color)
                            .cornerRadius(4)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 12))
                        Text("\(knot.strength)%")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(AppTheme.primary)
                }
            }
            
            Spacer()
        }
    }
    
    private var useCaseSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Best For")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            Text(knot.useCase)
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textSecondary)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.cardBackground)
                .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var lineTypesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Compatible Line Types")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            HStack(spacing: 8) {
                ForEach(knot.lineTypes, id: \.self) { lineType in
                    Text(lineType.description)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppTheme.cardBackground)
                        .cornerRadius(8)
                }
            }
        }
    }
    
    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How to Tie")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            VStack(spacing: 0) {
                ForEach(Array(knot.steps.enumerated()), id: \.offset) { index, step in
                    if index > 0 {
                        Divider().background(AppTheme.background)
                    }
                    
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.primary)
                                .frame(width: 28, height: 28)
                            
                            Text("\(index + 1)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text(step)
                            .font(.system(size: 15))
                            .foregroundColor(AppTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    .padding(16)
                }
            }
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pro Tips")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textMuted)
                .textCase(.uppercase)
            
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 18))
                    .foregroundColor(AppTheme.statusWarning)
                
                Text(knot.tips)
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusMedium)
        }
    }
}

// MARK: - Preview

struct KnotsGuideView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            KnotsGuideView()
        }
    }
}
