@testable import CouchTrackerCore
import RxSwift
import RxTest
import XCTest

final class AppStateStoreTest: XCTestCase {
  func testAppStateStore_receivesNewState_emitNewState() {
    // Given
    let store = AppStateStore(appState: AppState.initialState())
    let scheduler = TestScheduler(initialClock: 0)
    let observer = scheduler.createObserver(AppState.self)
    _ = store.observe().subscribe(observer)

    // When
    let state1 = AppState.initialState()
    store.newConfiguration(state: state1)

    let state2 = AppState(loginState: .notLogged, hideSpecials: true)
    store.newConfiguration(state: state2)

    // Then
    let expectedEvents = [Recorded.next(0, state1), Recorded.next(0, state2)]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testAppStateStore_doesnotEmitSameStateInARow() {
    // Given
    let store = AppStateStore(appState: AppState.initialState())
    let scheduler = TestScheduler(initialClock: 0)
    let observer = scheduler.createObserver(AppState.self)
    _ = store.observe().subscribe(observer)

    // When
    let state1 = AppState.initialState()
    store.newConfiguration(state: state1)

    store.newConfiguration(state: state1)

    // Then
    let expectedEvents = [Recorded.next(0, state1)]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
