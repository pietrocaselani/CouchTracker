@testable import CouchTrackerCore
import RxSwift
import RxTest
import TraktSwift
import XCTest

final class SearchInteractorTest: XCTestCase {
  private var scheduler: TestSchedulers!
  private var observer: TestableObserver<[SearchResult]>!

  override func setUp() {
    super.setUp()

    scheduler = TestSchedulers()
    observer = scheduler.createObserver([SearchResult].self)
  }

  override func tearDown() {
    observer = nil
    scheduler = nil
    super.tearDown()
  }

  func testSearchInteractor_fetchSuccessEmptyData_andEmitsEmptyDataAndOnCompleted() {
    let trakt = createTraktProviderMock()
    let searchProviderMock = trakt.search as! MoyaProviderMock

    let interactor = SearchService(traktProvider: trakt, schedulers: scheduler)

    let res = scheduler.start {
      interactor.search(query: "empty", types: [SearchType.movie], page: 0, limit: 30).asObservable()
    }

    let expectedEvents = [Recorded.next(201, [SearchResult]()), Recorded.completed(202)]
    XCTAssertEqual(res.events, expectedEvents)

    XCTAssertTrue(searchProviderMock.requestInvoked)
  }

  func testSearchInteractor_fetchSuccessReceivesData_andEmitDataAndOnCompleted() {
    let results = TraktEntitiesMock.createSearchResultsMock()
    let trakt = createTraktProviderMock()
    let interactor = SearchService(traktProvider: trakt, schedulers: scheduler)

    let res = scheduler.start {
      interactor.search(query: "Tron", types: [SearchType.movie], page: 0, limit: 30).asObservable()
    }

    let expectedEvents = [Recorded.next(201, results), Recorded.completed(202)]

    XCTAssertEqual(res.events, expectedEvents)
  }
}
