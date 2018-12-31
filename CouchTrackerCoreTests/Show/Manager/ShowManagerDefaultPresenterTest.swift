@testable import CouchTrackerCore
import RxTest
import XCTest

final class ShowManagerDefaultPresenterTest: XCTestCase {
  private var dataSource: ShowManagerMocks.DataSource!
  private var presenter: ShowManagerDefaultPresenter!
  private var observer: TestableObserver<ShowManagerViewState>!
  private var scheduler: TestScheduler!

  override func setUp() {
    super.setUp()

    scheduler = TestScheduler(initialClock: 0)
    observer = scheduler.createObserver(ShowManagerViewState.self)
    dataSource = ShowManagerMocks.DataSource()
    presenter = ShowManagerDefaultPresenter(dataSource: dataSource)
  }

  override func tearDown() {
    scheduler = nil
    observer = nil
    dataSource = nil
    presenter = nil

    super.tearDown()
  }

  func testShowManagerDefaultPresenterTest_viewWasLoaded_emitViewState() {
    // Given
    _ = presenter.observeViewState().subscribe(observer)

    // When
    presenter.viewDidLoad()

    // Then
    let expectedEvents = [Recorded.next(0, ShowManagerViewState.loading),
                          Recorded.next(0, ShowManagerViewState.showing(title: nil, pages: [], index: 0))]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testShowManagerDefaultPresenter_whenSelectTab_shouldNotifyDataSource() {
    // Given
    let newTabSelected = 100

    // When
    presenter.selectTab(index: newTabSelected)

    // Then
    XCTAssertTrue(dataSource.defaultModuleIndexInvoked)
    XCTAssertEqual(dataSource.defaultModuleIndexParameter, newTabSelected)
  }
}
