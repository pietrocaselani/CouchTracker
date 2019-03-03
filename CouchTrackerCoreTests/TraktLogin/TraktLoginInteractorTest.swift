@testable import CouchTrackerCore
import RxSwift
import RxTest
import XCTest

final class TraktLoginInteractorTest: XCTestCase {
  private let disposeBag = CompositeDisposable()

  override func tearDown() {
    disposeBag.dispose()
    super.tearDown()
  }

  func testTraktLoginInteractor_fetchLoginURLSuccess_emitsURL() {
    // Given
    let url = URL(validURL: "https://google.com/login")
    let trakt = TraktProviderMock(oauthURL: url)
    let policyDecider = TraktTokenPolicyDecider(traktProvider: trakt)
    let dataHolder = AppStateMock.DataHolderMock()
    let manager = DefaultAppStateManager(appState: .initialState(), trakt: trakt, dataHolder: dataHolder)

    let interactor = TraktLoginService(appStateManager: manager, policyDecider: policyDecider)

    // When
    let scheduler = TestScheduler(initialClock: 0)
    let res = scheduler.start { interactor.fetchLoginURL().asObservable() }

    // Then
    let expectedEvents = [Recorded.next(200, url),
                          Recorded.completed(200)]

    XCTAssertEqual(res.events, expectedEvents)
  }
}
