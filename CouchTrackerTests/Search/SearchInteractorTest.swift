import XCTest
import RxTest
import RxSwift
import TraktSwift

final class SearchInteractorTest: XCTestCase {
  private let scheduler = TestScheduler(initialClock: 0)
  private var observer: TestableObserver<[SearchResult]>!

  override func setUp() {
    super.setUp()

    observer = scheduler.createObserver([SearchResult].self)
  }

  override func tearDown() {
    observer = nil
    super.tearDown()
  }

  func testSearchInteractor_fetchSuccessEmptyData_andEmitsEmptyDataAndOnCompleted() {
    let interactor = SearchService(repository: SearchStoreMock(results: [SearchResult]()))

    let disposable = interactor.searchMovies(query: "Cool movie").subscribe(observer)

    scheduler.scheduleAt(500) { disposable.dispose() }

    let expectedEvents: [Recorded<Event<[SearchResult]>>] = [next(0, [SearchResult]()), completed(0)]

    RXAssertEvents(observer, expectedEvents)
  }

  func testSearchInteractor_fetchSuccessReceivesData_andEmitDataAndOnCompleted() {
    let results = TraktEntitiesMock.createSearchResultsMock()

    let interactor = SearchService(repository: SearchStoreMock(results: results))
    let disposable = interactor.searchMovies(query: "Tron").subscribe(observer)

    scheduler.scheduleAt(500) { disposable.dispose() }

    let expectedEvents: [Recorded<Event<[SearchResult]>>] = [next(0, results), completed(0)]

    RXAssertEvents(observer, expectedEvents)
  }
}
