@testable import CouchTrackerCore
import RxSwift
import TraktSwift
import XCTest

final class ShowsProgressMoyaNetworkTest: XCTestCase {
  func testShowsProgressMoyaNetwork_shouldRequest() {
    // Given
    let trakt = createTraktProviderMock()
    let network = ShowsProgressMoyaNetwork(trakt: trakt)

    // When
    let single: Single<[BaseShow]> = network.fetchWatchedShows(extended: Extended.full)

    // Then
    let testExpectation = expectation(description: "Expect to receive shows")

    _ = single.subscribe(onSuccess: { shows in
      testExpectation.fulfill()

      let provider = trakt.sync as! MoyaProviderMock

      XCTAssertFalse(shows.isEmpty)
      XCTAssertTrue(provider.requestInvoked)
      XCTAssertEqual(provider.requestInvokedCount, 1)
    })

    wait(for: [testExpectation], timeout: 1)
  }
}
