import Foundation
import SwiftUI

class DataManager: ObservableObject {
    @Published var rods: [FishingRod] = []
    @Published var trips: [FishingTrip] = []
    
    private let rodsKey = "fishing_rods"
    private let tripsKey = "fishing_trips"
    
    init() {
        loadData()
    }
    
    // MARK: - Persistence
    
    private func loadData() {
        if let rodsData = UserDefaults.standard.data(forKey: rodsKey),
           let decoded = try? JSONDecoder().decode([FishingRod].self, from: rodsData) {
            rods = decoded
        }
        
        if let tripsData = UserDefaults.standard.data(forKey: tripsKey),
           let decoded = try? JSONDecoder().decode([FishingTrip].self, from: tripsData) {
            trips = decoded
        }
    }
    
    private func saveRods() {
        if let encoded = try? JSONEncoder().encode(rods) {
            UserDefaults.standard.set(encoded, forKey: rodsKey)
        }
    }
    
    private func saveTrips() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: tripsKey)
        }
    }
    
    // MARK: - Rod Operations
    
    func addRod(_ rod: FishingRod) {
        var newRod = rod
        let initialChange = LineChange(
            date: rod.lastChangeDate,
            reason: .newRod,
            daysUsed: 0,
            tripsUsed: 0
        )
        newRod.changeHistory = [initialChange]
        rods.append(newRod)
        saveRods()
    }
    
    func updateRod(_ rod: FishingRod) {
        if let index = rods.firstIndex(where: { $0.id == rod.id }) {
            rods[index] = rod
            saveRods()
        }
    }
    
    func deleteRod(_ rod: FishingRod) {
        rods.removeAll { $0.id == rod.id }
        saveRods()
    }
    
    func changeLine(for rodId: UUID, reason: ChangeReason) {
        guard let index = rods.firstIndex(where: { $0.id == rodId }) else { return }
        
        let rod = rods[index]
        let change = LineChange(
            date: Date(),
            reason: reason,
            daysUsed: rod.daysSinceChange,
            tripsUsed: rod.usageCount
        )
        
        rods[index].changeHistory.insert(change, at: 0)
        rods[index].lastChangeDate = Date()
        rods[index].usageCount = 0
        rods[index].fishCaught = 0
        saveRods()
    }
    
    func snoozeReminder(for rodId: UUID, days: Int = 7) {
        guard let index = rods.firstIndex(where: { $0.id == rodId }) else { return }
        rods[index].reminderDays += days
        saveRods()
    }
    
    // MARK: - Trip Operations
    
    func addTrip(_ trip: FishingTrip) {
        trips.append(trip)
        saveTrips()
        
        // Update rods usage
        for rodId in trip.rodIds {
            if let index = rods.firstIndex(where: { $0.id == rodId }) {
                rods[index].usageCount += 1
                let fishPerRod = trip.fishCaught / max(1, trip.rodIds.count)
                rods[index].fishCaught += fishPerRod
            }
        }
        saveRods()
    }
    
    // MARK: - Queries
    
    var urgentReminders: [FishingRod] {
        rods.filter { $0.status == .replace }
    }
    
    var upcomingReminders: [FishingRod] {
        rods.filter { $0.status == .consider }
    }
    
    var sortedRodsByStatus: [FishingRod] {
        rods.sorted { rod1, rod2 in
            if rod1.status == rod2.status {
                return rod1.healthPercentage < rod2.healthPercentage
            }
            let statusOrder: [LineStatus] = [.replace, .consider, .good]
            let index1 = statusOrder.firstIndex(of: rod1.status) ?? 0
            let index2 = statusOrder.firstIndex(of: rod2.status) ?? 0
            return index1 < index2
        }
    }
    
    // MARK: - Statistics
    
    var totalRods: Int { rods.count }
    
    var averageLineAge: Int {
        guard !rods.isEmpty else { return 0 }
        return rods.reduce(0) { $0 + $1.daysSinceChange } / rods.count
    }
    
    var averageUsage: Int {
        guard !rods.isEmpty else { return 0 }
        return rods.reduce(0) { $0 + $1.usageCount } / rods.count
    }
    
    var oldestLine: FishingRod? {
        rods.max { $0.daysSinceChange < $1.daysSinceChange }
    }
    
    var mostUsedRod: FishingRod? {
        rods.max { $0.usageCount < $1.usageCount }
    }
    
    var totalLineChanges: Int {
        rods.reduce(0) { $0 + $1.changeHistory.count }
    }
    
    var lineTypeDistribution: [(LineType, Int)] {
        var counts: [LineType: Int] = [:]
        for rod in rods {
            counts[rod.lineType, default: 0] += 1
        }
        return counts.sorted { $0.value > $1.value }
    }
}
