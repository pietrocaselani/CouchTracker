@testable import CouchTrackerCore
import RxTest
import XCTest

final class MoviesManagerDefaultPresenterTest: XCTestCase {
  private var dataSource: MoviesManagerMocks.DataSource!
  private var presenter: MoviesManagerDefaultPresenter!
  private var scheduler: TestScheduler!
  private var observer: TestableObserver<MoviesManagerViewState>!

  override func setUp() {
    super.setUp()

    let creator = MoviesManagerMocks.ModuleCreator()

    scheduler = TestScheduler(initialClock: 0)
    observer = scheduler.createObserver(MoviesManagerViewState.self)
    dataSource = MoviesManagerMocks.DataSource(creator: creator)
    presenter = MoviesManagerDefaultPresenter(dataSource: dataSource)
  }

  override func tearDown() {
    dataSource = nil
    presenter = nil
    scheduler = nil
    observer = nil

    super.tearDown()
  }

  func testMoviesManagerDefaultPresenter_whenViewIsLoaded_emitViewState() {
    // Given
    _ = presenter.observeViewState().subscribe(observer)

    // When
    presenter.viewDidLoad()

    // Then
    let pages = [ModulePage(page: BaseViewMock(title: "Trending"), title: "Trending")]
    let index = 2

    let expectedEvents = [Recorded.next(0, MoviesManagerViewState.loading),
                          Recorded.next(0, MoviesManagerViewState.showing(pages: pages, selectedIndex: index))]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testMoviesManagerDefaultPresenter_whenChangeTab_notifyDataSource() {
    // When
    presenter.selectTab(index: 10)

    // Then
    XCTAssertEqual(dataSource.defaultModuleIndex, 10)
    XCTAssertEqual(dataSource.defaultModuleIndexInvokedCount, 1)
  }
}
