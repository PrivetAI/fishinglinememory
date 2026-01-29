import Foundation

enum LineType: String, Codable, CaseIterable {
    case monofilament = "Monofilament"
    case braided = "Braided"
    case fluorocarbon = "Fluorocarbon"
    case hybrid = "Hybrid"
    
    var description: String {
        return rawValue
    }
    
    var recommendedDays: Int {
        switch self {
        case .monofilament:
            return 60
        case .braided:
            return 120
        case .fluorocarbon:
            return 90
        case .hybrid:
            return 75
        }
    }
    
    var recommendedTrips: Int {
        switch self {
        case .monofilament:
            return 20
        case .braided:
            return 40
        case .fluorocarbon:
            return 30
        case .hybrid:
            return 25
        }
    }
}

enum ChangeReason: String, Codable, CaseIterable {
    case wear = "Wear"
    case broke = "Line Broke"
    case scheduled = "Scheduled"
    case newRod = "New Rod"
}
