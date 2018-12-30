@testable import CouchTrackerCore
import RxTest
import XCTest

final class ShowsManagerPresenterTest: XCTestCase {
  private var dataSource: ShowsManagerDataSourceMock!
  private var presenter: ShowsManagerPresenter!
  private var scheduler: TestScheduler!
  private var observer: TestableObserver<ShowsManagerViewState>!

  private func setup(_ index: Int = 0) {
    let page1 = ModulePage(page: BaseViewMock(), title: "Page1")
    let page2 = ModulePage(page: BaseViewMock(), title: "Page2")
    let page3 = ModulePage(page: BaseViewMock(), title: "Page3")

    dataSource = ShowsManagerDataSourceMock(modulePages: [page1, page2, page3], index: index)

    presenter = ShowsManagerDefaultPresenter(dataSource: dataSource)

    scheduler = TestScheduler(initialClock: 0)
    observer = scheduler.createObserver(ShowsManagerViewState.self)
  }

  override func tearDown() {
    scheduler = nil
    observer = nil
    dataSource = nil
    presenter = nil

    super.tearDown()
  }

  func testShowsManagerPresenter_initializeWithRightIndex() {
    // Given
    setup(1)

    // When
    _ = presenter.observeViewState().subscribe(observer)

    presenter.viewDidLoad()

    // Then
    let page1 = ModulePage(page: BaseViewMock(), title: "Page1")
    let page2 = ModulePage(page: BaseViewMock(), title: "Page2")
    let page3 = ModulePage(page: BaseViewMock(), title: "Page3")
    let pages = [page1, page2, page3]
    let index = 1

    let expectedEvents = [Recorded.next(0, ShowsManagerViewState.loading),
                          Recorded.next(0, ShowsManagerViewState.showing(pages: pages, selectedIndex: index))]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testShowsManagerPresenter_selectTab_notifyDataSource() {
    // Given
    setup(0)

    // When
    presenter.selectTab(index: 2)

    // Then
    XCTAssertTrue(dataSource.defaultModuleIndexInvoked)
    XCTAssertEqual(dataSource.defaultModuleIndexParameter, 2)
  }
}
