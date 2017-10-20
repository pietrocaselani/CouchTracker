import XCTest

final class ShowsProgressPresenterTest: XCTestCase {
  private let view = ShowsProgressMocks.ShowsProgressViewMock()
  private let router = ShowsProgressMocks.ShowsProgressRouterMock()
  private let repository = ShowsProgressMocks.ShowsProgressRepositoryMock(trakt: traktProviderMock, cache: AnyCache(CacheMock()))
  private let dataSource = ShowsProgressMocks.ShowProgressDataSourceMock()
  private let showProgressInteractor = ShowProgressMocks.ShowProgressServiceMock(repository: ShowProgressMocks.showProgressRepository)

  func testShowsProgressPresenter_receivesEmptyData_notifyView() {
    //Given
    let interactor = ShowsProgressMocks.EmptyShowsProgressInteractorMock(repository: repository, showProgressInteractor: showProgressInteractor)
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor, dataSource: dataSource, router: router)

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(view.showEmptyViewInvoked)
    XCTAssertTrue(view.updateFinishedInvoked)
    XCTAssertEqual(dataSource.viewModelCount(), 0)
  }

  func testShowsProgressPresenter_receivesData_notifyView() {
    //Given
    let interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, showProgressInteractor: showProgressInteractor)
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor, dataSource: dataSource, router: router)

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
    let interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, showProgressInteractor: showProgressInteractor)
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor, dataSource: dataSource, router: router)
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
