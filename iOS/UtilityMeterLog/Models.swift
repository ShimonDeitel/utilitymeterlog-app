import Foundation

struct ReadingEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var meterType: String
    var reading: String
    var dateISO: String

    init(id: UUID = UUID(), createdAt: Date = Date(), meterType: String = "", reading: String = "", dateISO: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.meterType = meterType
        self.reading = reading
        self.dateISO = dateISO
    }
}
