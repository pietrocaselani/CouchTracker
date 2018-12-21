@testable import CouchTrackerCore
import RxSwift
import RxTest
import TraktSwift
import XCTest

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
    let repository = SearchMocks.Repository()
    let interactor = SearchService(repository: repository)

    let disposable = interactor.search(query: "Cool movie", types: [SearchType.movie]).asObservable().subscribe(observer)

    scheduler.scheduleAt(500) { disposable.dispose() }

    let expectedEvents: [Recorded<Event<[SearchResult]>>] = [Recorded.next(0, [SearchResult]()), Recorded.completed(0)]

    RXAssertEvents(observer, expectedEvents)
    XCTAssertTrue(repository.searchInvoked)

    guard let parameters = repository.searchParameters else {
      XCTFail("searchParameters can't be nil")
      return
    }

    XCTAssertEqual(parameters.query, "Cool movie")
    XCTAssertEqual(parameters.types, [SearchType.movie])
    XCTAssertEqual(parameters.page, 0)
    XCTAssertEqual(parameters.limit, 50)
  }

  func testSearchInteractor_fetchSuccessReceivesData_andEmitDataAndOnCompleted() {
    let results = TraktEntitiesMock.createSearchResultsMock()

    let interactor = SearchService(repository: SearchMocks.Repository(results: results))
    let disposable = interactor.search(query: "Tron", types: [SearchType.movie]).asObservable().subscribe(observer)

    scheduler.scheduleAt(500) { disposable.dispose() }

    let expectedEvents: [Recorded<Event<[SearchResult]>>] = [Recorded.next(0, results), Recorded.completed(0)]

    RXAssertEvents(observer, expectedEvents)
  }

  func testSearchInteractor_invokeRepositoryWithCorrectParameters() {
    let repository = SearchMocks.Repository()
    let interactor = SearchService(repository: repository)

    _ = interactor.search(query: "Query cool", types: [.list, .movie, .person, .none])
  }
}
