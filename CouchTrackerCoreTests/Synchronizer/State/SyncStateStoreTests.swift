@testable import CouchTrackerCore
import RxTest
import XCTest

final class SyncStateStoreTests: XCTestCase {
  func testSyncStateStore_receivesNewState_emitNewState() {
    // Given
    let store = SyncStateStore()
    let scheduler = TestScheduler(initialClock: 0)
    let observer = scheduler.createObserver(SyncState.self)
    _ = store.observe().subscribe(observer)

    // When
    let state1 = SyncState.initial
    store.newSyncState(state: state1)

    let state2 = SyncState(watchedShowsSyncState: .syncing)
    store.newSyncState(state: state2)

    // Then
    let expectedEvents = [Recorded.next(0, state1), Recorded.next(0, state2)]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testSyncStateStore_doesnotEmitSameStateInARow() {
    // Given
    let store = SyncStateStore()
    let scheduler = TestScheduler(initialClock: 0)
    let observer = scheduler.createObserver(SyncState.self)
    _ = store.observe().subscribe(observer)

    // When
    let state1 = SyncState.initial
    store.newSyncState(state: state1)

    store.newSyncState(state: state1)

    // Then
    let expectedEvents = [Recorded.next(0, state1)]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
