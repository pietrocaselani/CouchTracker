import TraktSwift
import XCTest
import Moya

@testable import CouchTrackerCore

final class SearchAPIRepositoryTest: XCTestCase {
	func testSearchAPIRepository_whenSearch_shouldInvokeNetwork() {
		//Given
		let trakt = createTraktProviderMock()
		let schedulers = TestSchedulers()
		let repository = SearchAPIRepository(traktProvider: trakt, schedulers: schedulers)

		//When
		_ = schedulers.testScheduler.start {
			repository.search(query: "Batman", types: [SearchType.movie, SearchType.show], page: 2, limit: 30).asObservable()
		}

		//Then
		guard let provider = trakt.search as? MoyaProviderMock else {
			XCTFail("Should be an instance of MoyaProviderMock")
			return
		}
		XCTAssertTrue(provider.requestInvoked)

		guard let target = provider.targetInvoked else {
			XCTFail("Should not be nil")
			return
		}

		if case .textQuery(let params) = target {
			XCTAssertEqual(params.types, [SearchType.movie, SearchType.show])
			XCTAssertEqual(params.query, "Batman")
			XCTAssertEqual(params.page, 2)
			XCTAssertEqual(params.limit, 30)
		} else {
			XCTFail("Should be a text query")
		}
	}
}
