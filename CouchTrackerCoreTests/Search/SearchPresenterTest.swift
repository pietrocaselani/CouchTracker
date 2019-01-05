@testable import CouchTrackerCore
import RxTest
import TraktSwift
import XCTest

final class SearchPresenterTest: XCTestCase {
  private var schedulers: TestSchedulers!
  private var observer: TestableObserver<SearchState>!

  override func setUp() {
    super.setUp()

    schedulers = TestSchedulers(initialClock: 0)
    observer = schedulers.createObserver(SearchState.self)
  }

  override func tearDown() {
    schedulers = nil
    observer = nil

    super.tearDown()
  }

  func testSearchPresenter_performSearchSuccess_emitsResultsAndComplete() {
    // Given
    let results = TraktEntitiesMock.createSearchResultsMock()
    let interactor = SearchMocks.Interactor(results: results)
    let router = SearchMocks.Router()
    let presenter = SearchDefaultPresenter(interactor: interactor,
                                           types: [SearchType.movie],
                                           router: router,
                                           schedulers: schedulers)

    _ = presenter.observeSearchState().subscribe(observer)

    // When
    presenter.search(query: "Tron")

    // Then
    let expectedEntities = TraktEntitiesMock.createSearchResultEntitiesMock()

    let expectedEvents = [Recorded.next(0, SearchState.notSearching),
                          Recorded.next(0, SearchState.searching),
                          Recorded.next(0, SearchState.results(entities: expectedEntities))]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testSearchPresenter_performSearchReceivesNoData_emitsEmptyResultState() {
    // Given
    let interactor = SearchMocks.Interactor()
    let router = SearchMocks.Router()
    let presenter = SearchDefaultPresenter(interactor: interactor,
                                           types: [SearchType.movie],
                                           router: router,
                                           schedulers: schedulers)

    _ = presenter.observeSearchState().subscribe(observer)

    // When
    presenter.search(query: "Tron")

    // Then
    let expectedEvents = [Recorded.next(0, SearchState.notSearching),
                          Recorded.next(0, SearchState.searching),
                          Recorded.next(0, SearchState.emptyResults)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testSearchPresenter_performSearchFailure_emitsErrorState() {
    // Given
    let userInfo = [NSLocalizedDescriptionKey: "There is no active connection"]
    let error = NSError(domain: "io.github.pietrocaselani.CouchTracker", code: 10, userInfo: userInfo)
    let interactor = SearchMocks.Interactor(error: error)
    let router = SearchMocks.Router()
    let presenter = SearchDefaultPresenter(interactor: interactor, types: [.movie], router: router, schedulers: schedulers)

    _ = presenter.observeSearchState().subscribe(observer)

    // When
    presenter.search(query: "Tron")

    // Then
    let expectedEvents = [Recorded.next(0, SearchState.notSearching),
                          Recorded.next(0, SearchState.searching),
                          Recorded.next(0, SearchState.error(error: error))]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testSearchPresenter_performCancel_emitsNotSearching() {
    // Given
    let interactor = SearchMocks.Interactor()
    let router = SearchMocks.Router()
    let presenter = SearchDefaultPresenter(interactor: interactor,
                                           types: [SearchType.movie],
                                           router: router,
                                           schedulers: schedulers)

    _ = presenter.observeSearchState().subscribe(observer)

    // When
    presenter.search(query: "Tron")
    presenter.cancelSearch()

    // Then
    let expectedEvents = [Recorded.next(0, SearchState.notSearching),
                          Recorded.next(0, SearchState.searching),
                          Recorded.next(0, SearchState.emptyResults),
                          Recorded.next(0, SearchState.notSearching)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testSearchPresenter_selectItem_notifyRouter() {
    // Given
    let results = TraktEntitiesMock.createSearchResultsMock()

    let expectedEntities = TraktEntitiesMock.createSearchResultEntitiesMock()

    let interactor = SearchMocks.Interactor(results: results)
    let router = SearchMocks.Router()
    let presenter = SearchDefaultPresenter(interactor: interactor,
                                           types: [SearchType.movie],
                                           router: router,
                                           schedulers: schedulers)

    _ = presenter.observeSearchState().subscribe(observer)

    presenter.search(query: "Tron")

    // When
    let selectedEntity = expectedEntities[1]
    presenter.select(entity: selectedEntity)

    // Then
    XCTAssertEqual(router.showViewInvokedCount, 1)
    XCTAssertEqual(router.showViewLastParameter, selectedEntity)
  }
}
