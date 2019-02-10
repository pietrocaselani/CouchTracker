@testable import CouchTrackerCore
import RxSwift
import XCTest

final class TraktLoginInteractorTest: XCTestCase {
  private let disposeBag = CompositeDisposable()

  override func tearDown() {
    disposeBag.dispose()
    super.tearDown()
  }

  func testTraktLoginInteractor_fetchLoginURLSuccess_emitsURL() {
    // Given
    let url = URL(string: "https://google.com/login")
    let trakt = TraktProviderMock(oauthURL: nil)
    let policyDecider = TraktTokenPolicyDecider(traktProvider: trakt)
    let dataHolder = AppStateMock.DataHolderMock()
    let manager = AppStateManager(appState: .initialState(), trakt: trakt, dataHolder: dataHolder)

    let interactor = TraktLoginService(appStateManager: manager, policyDecider: policyDecider)

    // When
    let single = interactor.fetchLoginURL()

    // Then
    let resultExpectation = expectation(description: "Expect login URL")

    let disposable = single.subscribe(onSuccess: { resultURL in
      resultExpectation.fulfill()
      XCTAssertEqual(resultURL, url)
    })
    _ = disposeBag.insert(disposable)

    wait(for: [resultExpectation], timeout: 1)
  }
}
