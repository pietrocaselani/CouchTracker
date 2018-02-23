import XCTest
import RxTest
import RxSwift
import TraktSwift
@testable import CouchTrackerCore

final class ShowDetailsRepositoryTest: XCTestCase {
	private let scheduler = TestSchedulers()

	func testFetchDetails_emitsMockData() {
		let repository = ShowDetailsAPIRepository(traktProvider: createTraktProviderMock(), schedulers: scheduler)

		let testExpectation = expectation(description: "Expect full game of thones data")

		let expectedShow = TraktEntitiesMock.createTraktShowDetails()

		_ = repository.fetchDetailsOfShow(with: "game-of-thrones", extended: .fullEpisodes)
				.subscribe(onSuccess: { show in
					testExpectation.fulfill()
					XCTAssertEqual(show, expectedShow)
				}, onError: {
					XCTFail($0.localizedDescription)
				})

		scheduler.start()

		wait(for: [testExpectation], timeout: 0.4)
	}
}
