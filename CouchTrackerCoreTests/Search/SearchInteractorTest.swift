import XCTest
import RxTest
import RxSwift
import TraktSwift
@testable import CouchTrackerCore

final class SearchInteractorTest: XCTestCase {
	private var scheduler: TestScheduler!
	private var observer: TestableObserver<[SearchResult]>!

	override func setUp() {
		super.setUp()

		scheduler = TestScheduler(initialClock: 0)
		observer = scheduler.createObserver([SearchResult].self)
	}

	override func tearDown() {
		observer = nil
		scheduler = nil
		super.tearDown()
	}

	func testSearchInteractor_fetchSuccessEmptyData_andEmitsEmptyDataAndOnCompleted() {
		let interactor = SearchService(repository: SearchMocks.Repository(results: [SearchResult]()))

		let disposable = interactor.search(query: "Cool movie", types: [SearchType.movie]).asObservable().subscribe(observer)

		scheduler.scheduleAt(500) { disposable.dispose() }

		let expectedEvents: [Recorded<Event<[SearchResult]>>] = [next(0, [SearchResult]()), completed(0)]

		RXAssertEvents(observer, expectedEvents)
	}

	func testSearchInteractor_fetchSuccessReceivesData_andEmitDataAndOnCompleted() {
		let results = TraktEntitiesMock.createSearchResultsMock()

		let interactor = SearchService(repository: SearchMocks.Repository(results: results))
		let disposable = interactor.search(query: "Tron", types: [SearchType.movie]).asObservable().subscribe(observer)

		scheduler.scheduleAt(500) { disposable.dispose() }

		let expectedEvents: [Recorded<Event<[SearchResult]>>] = [next(0, results), completed(0)]

		RXAssertEvents(observer, expectedEvents)
	}
}
