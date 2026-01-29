import Foundation

struct LineChange: Codable, Identifiable {
    let id: UUID
    let date: Date
    let reason: ChangeReason
    let daysUsed: Int
    let tripsUsed: Int
    
    init(id: UUID = UUID(), date: Date = Date(), reason: ChangeReason, daysUsed: Int, tripsUsed: Int) {
        self.id = id
        self.date = date
        self.reason = reason
        self.daysUsed = daysUsed
        self.tripsUsed = tripsUsed
    }
}
