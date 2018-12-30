@testable import CouchTrackerCore
import RxTest
import XCTest

final class AppFlowPresenterTests: XCTestCase {
  private var dataSource: AppFlowMocks.ModuleDataSource!
  private var repository: AppFlowMocks.Repository!
  private var presenter: AppFlowDefaultPresenter!
  private var scheduler: TestScheduler!
  private var testableObserver: TestableObserver<AppFlowViewState>!

  override func setUp() {
    super.setUp()

    scheduler = TestScheduler(initialClock: 0)
    testableObserver = scheduler.createObserver(AppFlowViewState.self)
    repository = AppFlowMocks.Repository()
    dataSource = AppFlowMocks.ModuleDataSource()
    presenter = AppFlowDefaultPresenter(repository: repository, moduleDataSource: dataSource)
  }

  override func tearDown() {
    super.tearDown()

    repository = nil
    dataSource = nil
    presenter = nil
  }

  func testAppFlowPresenter_viewStateAlwaysStartsLoading() {
    // When
    let res = scheduler.start {
      self.presenter.observeViewState()
    }

    presenter.viewDidLoad()

    // Then
    let firstEvent = res.events.first
    let expectedFirstEvent = Recorded.next(200, AppFlowViewState.loading)

    XCTAssertEqual(firstEvent, expectedFirstEvent)
  }

  func testAppFlowPresenter_viewDidLoad_shoulEmitViewState() {
    // Given
    repository.lastSelectedTab = 2

    _ = presenter.observeViewState().subscribe(testableObserver)

    // When
    presenter.viewDidLoad()

    // Then
    let pages = ModulePageMocks.createPages(count: 3)
    let tabIndex = 2

    let expectedEvents = [Recorded.next(0, AppFlowViewState.loading),
                          Recorded.next(0, AppFlowViewState.showing(pages: pages, selectedIndex: tabIndex))]

    XCTAssertEqual(testableObserver.events, expectedEvents)
    XCTAssertTrue(repository.lastSelectedTabInvoked)
    XCTAssertTrue(dataSource.modulePagesInvoked)
  }

  func testAppFlowPresenter_receivesNewTabSelected_shouldNotifyRepository() {
    // Given
    repository.lastSelectedTab = 1

    // When
    presenter.selectTab(index: 2)

    // Then
    XCTAssertEqual(repository.lastSelectedTab, 2)
  }
}
