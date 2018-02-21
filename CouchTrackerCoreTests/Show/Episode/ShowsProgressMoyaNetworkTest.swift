import XCTest
import TraktSwift
import RxSwift
@testable import CouchTrackerCore

final class ShowsProgressMoyaNetworkTest: XCTestCase {
	func testShowsProgressMoyaNetwork_shouldRequest() {
		//Given
		let network = ShowsProgressMoyaNetwork(trakt: traktProviderMock)

		//When
		let single: Single<[BaseShow]> = network.fetchWatchedShows(extended: Extended.full)

		//Then
		let testExpectation = expectation(description: "Expect to receive shows")

		_ = single.subscribe(onSuccess: { shows in
			testExpectation.fulfill()
			
			let provider = traktProviderMock.sync as! MoyaProviderMock

			XCTAssertFalse(shows.isEmpty)
			XCTAssertTrue(provider.requestInvoked)
			XCTAssertEqual(provider.requestInvokedCount, 1)
		})

		wait(for: [testExpectation], timeout: 1)
	}
}
