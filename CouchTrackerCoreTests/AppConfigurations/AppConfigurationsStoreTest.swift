@testable import CouchTrackerCore
import RxSwift
import RxTest
import XCTest

final class AppConfigurationsStoreTest: XCTestCase {
  func testAppConfigurationsStore_receivesNewState_emitNewState() {
    // Given
    let store = AppConfigurationsStore(appState: AppConfigurationsState.initialState())
    let scheduler = TestScheduler(initialClock: 0)
    let observer = scheduler.createObserver(AppConfigurationsState.self)
    _ = store.observe().subscribe(observer)

    // When
    let state1 = AppConfigurationsState.initialState()
    store.newConfiguration(state: state1)

    let state2 = AppConfigurationsState(loginState: .notLogged, hideSpecials: true)
    store.newConfiguration(state: state2)

    // Then
    let expectedEvents = [Recorded.next(0, state1), Recorded.next(0, state2)]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testAppConfigurationsStore_doesnotEmitSameStateInARow() {
    // Given
    let store = AppConfigurationsStore(appState: AppConfigurationsState.initialState())
    let scheduler = TestScheduler(initialClock: 0)
    let observer = scheduler.createObserver(AppConfigurationsState.self)
    _ = store.observe().subscribe(observer)

    // When
    let state1 = AppConfigurationsState.initialState()
    store.newConfiguration(state: state1)

    store.newConfiguration(state: state1)

    // Then
    let expectedEvents = [Recorded.next(0, state1)]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
