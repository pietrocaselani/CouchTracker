import XCTest

final class ShowsProgressPresenterTest: XCTestCase {
  private let view = ShowsProgressMocks.ShowsProgressViewMock()
  private let router = ShowsProgressMocks.ShowsProgressRouterMock()
  private let repository = ShowsProgressMocks.ShowsProgressRepositoryMock(trakt: traktProviderMock)
  private let dataSource = ShowsProgressMocks.ShowProgressViewDataSourceMock()

  func testShowsProgressPresenter_receivesEmptyData_notifyView() {
    //Given
    let interactor = ShowsProgressMocks.EmptyShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor, viewDataSource: dataSource, router: router)

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(view.showEmptyViewInvoked)
    XCTAssertTrue(view.updateFinishedInvoked)
    XCTAssertEqual(dataSource.viewModelCount(), 0)
  }

  func testShowsProgressPresenter_receivesData_notifyView() {
    //Given
    let interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor, viewDataSource: dataSource, router: router)

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(view.newViewModelAvailableInvoked)
    XCTAssertEqual(view.newViewModelAvailableParameters, [0, 1, 2])
    XCTAssertTrue(view.updateFinishedInvoked)
    XCTAssertEqual(dataSource.viewModelCount(), 3)
  }

  func testShowsProgressPresenter_forceUpdate_reloadView() {
    //Given
    let interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor, viewDataSource: dataSource, router: router)
    presenter.viewDidLoad()

    //When
    presenter.updateShows()

    //Then
    XCTAssertTrue(view.newViewModelAvailableInvoked)
    XCTAssertEqual(view.newViewModelAvailableParameters, [0, 1, 2, 0, 1, 2])
    XCTAssertTrue(view.updateFinishedInvoked)
    XCTAssertEqual(dataSource.viewModelCount(), 3)
  }
}
