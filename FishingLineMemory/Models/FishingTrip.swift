import Foundation

struct FishingTrip: Codable, Identifiable {
    let id: UUID
    let date: Date
    let rodIds: [UUID]
    var fishCaught: Int
    var notes: String?
    
    init(id: UUID = UUID(), date: Date = Date(), rodIds: [UUID], fishCaught: Int = 0, notes: String? = nil) {
        self.id = id
        self.date = date
        self.rodIds = rodIds
        self.fishCaught = fishCaught
        self.notes = notes
    }
}
