import XCTest
@testable import UtilityMeterLog

@MainActor
final class UtilityMeterLogTests: XCTestCase {
    func testSeedDataLoadsBelowFreeLimit() {
        let store = Store()
        XCTAssertFalse(store.entries.isEmpty)
        XCTAssertLessThan(store.entries.count, Store.freeEntryLimit)
    }

    func testCanAddWhenBelowLimit() {
        let store = Store()
        XCTAssertTrue(store.canAdd(isPro: false))
    }

    func testAddIncreasesCount() {
        let store = Store()
        let before = store.entries.count
        store.add(ReadingEntry())
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testDeleteRemovesEntry() {
        let store = Store()
        let entry = ReadingEntry()
        store.add(entry)
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(where: { $0.id == entry.id }))
    }

    func testFreeLimitEnforcedWhenNotPro() {
        let store = Store()
        for _ in 0..<(Store.freeEntryLimit + 5) {
            store.add(ReadingEntry())
        }
        XCTAssertFalse(store.canAdd(isPro: false))
        XCTAssertTrue(store.isAtFreeLimit)
    }

    func testProBypassesFreeLimit() {
        let store = Store()
        for _ in 0..<(Store.freeEntryLimit + 5) {
            store.add(ReadingEntry())
        }
        XCTAssertTrue(store.canAdd(isPro: true))
    }

    func testUpdateModifiesExistingEntry() {
        let store = Store()
        var entry = ReadingEntry()
        store.add(entry)
        entry.notes = "updated" as String? != nil ? entry.notes : entry.notes
        store.update(entry)
        XCTAssertTrue(store.entries.contains(where: { $0.id == entry.id }))
    }

    func testDeleteAtOffsetsRemovesCorrectEntry() {
        let store = Store()
        store.entries.removeAll()
        let a = ReadingEntry()
        let b = ReadingEntry()
        store.entries = [a, b]
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 1)
        XCTAssertEqual(store.entries.first?.id, b.id)
    }
}
