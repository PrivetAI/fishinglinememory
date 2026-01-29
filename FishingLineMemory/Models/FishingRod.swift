import Foundation

struct FishingRod: Codable, Identifiable {
    let id: UUID
    var name: String
    var iconName: String
    var lineType: LineType
    var lineDiameter: Double // mm
    var lineStrength: Double? // lb
    var lineBrand: String?
    var lineLength: Double? // metres
    var lastChangeDate: Date
    var usageCount: Int
    var fishCaught: Int
    var reminderDays: Int
    var reminderTrips: Int
    var autoReminder: Bool
    var changeHistory: [LineChange]
    
    init(
        id: UUID = UUID(),
        name: String,
        iconName: String = "rod_1",
        lineType: LineType = .monofilament,
        lineDiameter: Double = 0.14,
        lineStrength: Double? = nil,
        lineBrand: String? = nil,
        lineLength: Double? = nil,
        lastChangeDate: Date = Date(),
        usageCount: Int = 0,
        fishCaught: Int = 0,
        reminderDays: Int = 60,
        reminderTrips: Int = 20,
        autoReminder: Bool = true,
        changeHistory: [LineChange] = []
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.lineType = lineType
        self.lineDiameter = lineDiameter
        self.lineStrength = lineStrength
        self.lineBrand = lineBrand
        self.lineLength = lineLength
        self.lastChangeDate = lastChangeDate
        self.usageCount = usageCount
        self.fishCaught = fishCaught
        self.reminderDays = reminderDays
        self.reminderTrips = reminderTrips
        self.autoReminder = autoReminder
        self.changeHistory = changeHistory
    }
    
    // MARK: - Computed Properties
    
    var daysSinceChange: Int {
        Calendar.current.dateComponents([.day], from: lastChangeDate, to: Date()).day ?? 0
    }
    
    var healthPercentage: Double {
        let daysFactor = min(1.0, Double(daysSinceChange) / Double(reminderDays))
        let tripsFactor = min(1.0, Double(usageCount) / Double(reminderTrips))
        let maxFactor = max(daysFactor, tripsFactor)
        return max(0, (1.0 - maxFactor) * 100)
    }
    
    var status: LineStatus {
        let health = healthPercentage
        if health > 50 {
            return .good
        } else if health > 20 {
            return .consider
        } else {
            return .replace
        }
    }
    
    var isOverdue: Bool {
        daysSinceChange >= reminderDays || usageCount >= reminderTrips
    }
    
    var daysUntilReminder: Int {
        max(0, reminderDays - daysSinceChange)
    }
    
    var tripsUntilReminder: Int {
        max(0, reminderTrips - usageCount)
    }
}

enum LineStatus: String {
    case good = "Good condition"
    case consider = "Consider changing"
    case replace = "Time to replace"
}
