@testable import CouchTrackerCore
import XCTest

final class ShowsProgressDefaultPresenterTest: XCTestCase {
  private let view = ShowsProgressMocks.ShowsProgressViewMock()
  private let router = ShowsProgressMocks.ShowsProgressRouterMock()
  private let repository = ShowsProgressMocks.ShowsProgressRepositoryMock(trakt: createTraktProviderMock())
  private let dataSource = ShowsProgressMocks.ShowProgressViewDataSourceMock()
  private let listStateDataSource = ShowsProgressMocks.ListStateDataSource()
  private var interactor: ShowsProgressInteractor!
  private var presenter: ShowsProgressDefaultPresenter!
  private var loginObservable: TraktLoginObservableMock!

  private func setupPresenter(_ loginState: TraktLoginState) {
    loginObservable = TraktLoginObservableMock(state: loginState)

    presenter = ShowsProgressDefaultPresenter(view: view, interactor: interactor, viewDataSource: dataSource, router: router, loginObservable: loginObservable)
  }

  func testShowsProgressPresenter_receivesNothing_notifyView() {
    // Given
    interactor = ShowsProgressMocks.EmptyShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.logged)

    // When
    presenter.viewDidLoad()

    // Then
    let viewExpectation = expectation(description: "Should update view")

    DispatchQueue.main.async {
      viewExpectation.fulfill()
      XCTAssertTrue(self.view.showEmptyViewInvoked)
      XCTAssertFalse(self.view.showErrorInvoked)
      XCTAssertTrue(self.dataSource.viewModels.isEmpty)
    }

    wait(for: [viewExpectation], timeout: 1)
  }

  func testShowsProgressPresenter_receivesData_notifyView() {
    // Given
    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.logged)

    // When
    presenter.viewDidLoad()

    // Then
    let viewExpectation = expectation(description: "Should update view")

    DispatchQueue.main.async {
      viewExpectation.fulfill()
      XCTAssertTrue(self.view.showViewModelsInvoked)
      XCTAssertEqual(self.dataSource.viewModels.count, 3)
      XCTAssertFalse(self.view.showErrorInvoked)
    }

    wait(for: [viewExpectation], timeout: 1)
  }

  func testShowsProgressPresenter_forceUpdate_reloadView() {
    // Given
    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.logged)
    presenter.viewDidLoad()

    // When
    presenter.updateShows()

    // Then
    let viewExpectation = expectation(description: "Should update view")

    DispatchQueue.main.async {
      viewExpectation.fulfill()
      XCTAssertTrue(self.dataSource.updateInvoked)
      XCTAssertTrue(self.view.showViewModelsInvoked)
      XCTAssertEqual(self.dataSource.viewModels.count, 3)
      XCTAssertFalse(self.view.showErrorInvoked)
    }

    wait(for: [viewExpectation], timeout: 1)
  }

  func testShowsProgressPresenter_notLoggedOnTrakt_notifyView() {
    // Given
    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.notLogged)

    // When
    presenter.viewDidLoad()

    // Then
    XCTAssertTrue(view.showErrorInvoked)
    XCTAssertEqual(view.showErrorParameters, "You need to login on Trakt to access this content")
    XCTAssertFalse(view.showViewModelsInvoked)
    XCTAssertFalse(view.showEmptyViewInvoked)
    XCTAssertFalse(view.showLoadingInvoked)
  }

  func testShowsProgressPresenter_receivesNotLoggedEvent_updateView() {
    // Given
    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.logged)

    presenter.viewDidLoad()

    // When
    loginObservable.changeTo(state: TraktLoginState.notLogged)

    // Then
    let viewExpectation = expectation(description: "Should update view")

    DispatchQueue.main.async {
      viewExpectation.fulfill()
      XCTAssertTrue(self.dataSource.updateInvoked)
      XCTAssertTrue(self.view.showViewModelsInvoked)
      XCTAssertTrue(self.view.showErrorInvoked)
      XCTAssertEqual(self.view.showErrorParameters, "You need to login on Trakt to access this content")
    }

    wait(for: [viewExpectation], timeout: 1)
  }

  func testShowsProgressDefaultPresenter_handleFilter_notifyView() {
    // Given
    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.logged)
    presenter.viewDidLoad()

    // When
    presenter.handleFilter()

    // Then
    let testExpectation = expectation(description: "Should show options")

    DispatchQueue.main.async {
      testExpectation.fulfill()
      XCTAssertTrue(self.view.showOptionsInvoked)
      guard let parameters = self.view.showOptionsParameters else {
        XCTFail()
        return
      }

      XCTAssertEqual(parameters.currentFilter, 0)
      XCTAssertEqual(parameters.currentSort, 0)
      XCTAssertEqual(parameters.filtering, ["None", "Watched", "Returning", "Returning and watched"])
      XCTAssertEqual(parameters.sorting, ["Title", "Remaining", "Last watched", "Release date"])
    }

    wait(for: [testExpectation], timeout: 1)
  }

  func testShowsProgressDefaultPresenter_handleDirection_updateViewAndViewDataSource() {
    // Given
    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.logged)
    presenter.viewDidLoad()

    // When
    presenter.handleDirection()

    // Then
    let testExpectation = expectation(description: "Should update view and data source")

    DispatchQueue.main.async {
      testExpectation.fulfill()
      XCTAssertTrue(self.view.reloadListInvoked)
      XCTAssertTrue(self.dataSource.setViewModelInvoked)

      let entity1 = ShowsProgressMocks.mockWatchedShowEntity()
      let entity2 = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode()
      let entity3 = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisodeDate()

      let viewModels = [entity1, entity2, entity3].map { WatchedShowEntityMapper.viewModel(for: $0) }

      XCTAssertEqual(self.dataSource.viewModels, viewModels.reversed())
    }

    wait(for: [testExpectation], timeout: 1)
  }

  func testShowsProgressDefaultPresenter_changeSortAndFilter_updateViewAndViewDataSource() {
    // Given
    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.logged)
    presenter.viewDidLoad()

    // When
    presenter.changeSort(to: 2, filter: 2)

    // Then
    let testExpectation = expectation(description: "Should update view and data source")

    DispatchQueue.main.async {
      testExpectation.fulfill()
      XCTAssertTrue(self.view.reloadListInvoked)
      XCTAssertTrue(self.dataSource.setViewModelInvoked)
    }

    wait(for: [testExpectation], timeout: 1)
  }

  func testShowsProgressDefaultPresenter_selectShow_notifyRouter() {
    // Given
    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.logged)
    presenter.viewDidLoad()

    let testExpectation = expectation(description: "Should notify router")

    DispatchQueue.main.async {
      testExpectation.fulfill()

      // When
      self.presenter.selectedShow(at: 1)

      // Then
      XCTAssertTrue(self.router.showTVShowInvoked)

      guard let receivedShow = self.router.showTVShowParameter else {
        XCTFail("Router parameter can't be nil")
        return
      }

      let expectedEntity = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode()

      XCTAssertEqual(receivedShow, expectedEntity)
    }

    wait(for: [testExpectation], timeout: 1)
  }

  func testShowsProgressDefaultPresenter_receivesErrorFromInteractor_notifyViewAndDataSource() {
    // Given
    let errorInteractor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    let message = "Realm file is corrupted"
    let userInfo = [NSLocalizedDescriptionKey: message]
    errorInteractor.error = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 35, userInfo: userInfo)
    interactor = errorInteractor
    setupPresenter(TraktLoginState.logged)

    // When
    presenter.viewDidLoad()

    // Then
    let testExpectation = expectation(description: "Should notify view and data source")

    DispatchQueue.main.async {
      testExpectation.fulfill()

      XCTAssertTrue(self.view.showErrorInvoked)
      XCTAssertTrue(self.dataSource.updateInvoked)

      guard let receivedMessage = self.view.showErrorParameters else {
        XCTFail("Error message can't be nil")
        return
      }

      XCTAssertEqual(receivedMessage, message)
    }

    wait(for: [testExpectation], timeout: 1)
  }

  func testShowsProgressDefaultPresenter_receivesEmptyData_notifyView() {
    // Given
    let emptyInteractor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    emptyInteractor.empty = true
    interactor = emptyInteractor
    setupPresenter(TraktLoginState.logged)

    // When
    presenter.viewDidLoad()

    // Then
    let testExpectation = expectation(description: "Should notify view and data source")

    DispatchQueue.main.async {
      testExpectation.fulfill()

      XCTAssertTrue(self.view.showEmptyViewInvoked)
      XCTAssertTrue(self.dataSource.setViewModelInvoked)
      XCTAssertTrue(self.dataSource.viewModels.isEmpty)
    }

    wait(for: [testExpectation], timeout: 1)
  }

  func testShowsProgressPresenter_receivesDataInPortugueseBrazil_notifyView() {
    // Given
    NSLocale.ct_overrideRuntimeLocale(Locale(identifier: "pt_BR"))
    Bundle.ct_overrideLanguage("pt-BR")
    NSTimeZone.ct_overrideRuntimeTimeZone(TimeZone(abbreviation: "BRT")!)

    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.logged)

    // When
    presenter.viewDidLoad()

    // Then
    let viewExpectation = expectation(description: "Should update view")

    let watched1 = WatchedShowViewModel(title: "The Americans", nextEpisode: "1x1 Winter Is Coming", nextEpisodeDate: "17 de abril", status: "5 remaining FX (US)", tmdbId: 46533)

    let watched2 = WatchedShowViewModel(title: "The Americans", nextEpisode: nil, nextEpisodeDate: "Em exibição", status: "5 remaining FX (US)", tmdbId: 46533)

    let watched3 = WatchedShowViewModel(title: "The Americans", nextEpisode: "1x1 Winter Is Coming", nextEpisodeDate: "Em exibição", status: "5 remaining FX (US)", tmdbId: 46533)

    let expectedViewModels = [watched1, watched2, watched3]

    DispatchQueue.main.async {
      viewExpectation.fulfill()
      XCTAssertTrue(self.view.showViewModelsInvoked)
      XCTAssertEqual(self.dataSource.viewModels, expectedViewModels)
      XCTAssertFalse(self.view.showErrorInvoked)
    }

    wait(for: [viewExpectation], timeout: 1)
  }

  func testShowsProgressPresenter_receivesDataInEnglish_notifyView() {
    // Given
    NSLocale.ct_overrideRuntimeLocale(Locale(identifier: "en_US_POSIX"))
    Bundle.ct_overrideLanguage("en")
    NSTimeZone.ct_overrideRuntimeTimeZone(TimeZone(abbreviation: "BRT")!)

    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.logged)

    // When
    presenter.viewDidLoad()

    // Then
    let viewExpectation = expectation(description: "Should update view")

    let watched1 = WatchedShowViewModel(title: "The Americans", nextEpisode: "1x1 Winter Is Coming", nextEpisodeDate: "Apr 17", status: "5 remaining FX (US)", tmdbId: 46533)

    let watched2 = WatchedShowViewModel(title: "The Americans", nextEpisode: nil, nextEpisodeDate: "Continuing", status: "5 remaining FX (US)", tmdbId: 46533)

    let watched3 = WatchedShowViewModel(title: "The Americans", nextEpisode: "1x1 Winter Is Coming", nextEpisodeDate: "Continuing", status: "5 remaining FX (US)", tmdbId: 46533)

    let expectedViewModels = [watched1, watched2, watched3]

    DispatchQueue.main.async {
      viewExpectation.fulfill()
      XCTAssertTrue(self.view.showViewModelsInvoked)
      XCTAssertEqual(self.dataSource.viewModels, expectedViewModels)
      XCTAssertFalse(self.view.showErrorInvoked)
    }

    wait(for: [viewExpectation], timeout: 1)
  }

  func testShowsProgressPresenter_receivesDataInOtherTimeZone_notifyView() {
    // Given
    NSLocale.ct_overrideRuntimeLocale(Locale(identifier: "en_US_POSIX"))
    Bundle.ct_overrideLanguage("en")
    NSTimeZone.ct_overrideRuntimeTimeZone(TimeZone(abbreviation: "BST")!)

    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.logged)

    // When
    presenter.viewDidLoad()

    // Then
    let viewExpectation = expectation(description: "Should update view")

    let watched1 = WatchedShowViewModel(title: "The Americans", nextEpisode: "1x1 Winter Is Coming", nextEpisodeDate: "Apr 18", status: "5 remaining FX (US)", tmdbId: 46533)

    let watched2 = WatchedShowViewModel(title: "The Americans", nextEpisode: nil, nextEpisodeDate: "Continuing", status: "5 remaining FX (US)", tmdbId: 46533)

    let watched3 = WatchedShowViewModel(title: "The Americans", nextEpisode: "1x1 Winter Is Coming", nextEpisodeDate: "Continuing", status: "5 remaining FX (US)", tmdbId: 46533)

    let expectedViewModels = [watched1, watched2, watched3]

    DispatchQueue.main.async {
      viewExpectation.fulfill()
      XCTAssertTrue(self.view.showViewModelsInvoked)
      XCTAssertEqual(self.dataSource.viewModels, expectedViewModels)
      XCTAssertFalse(self.view.showErrorInvoked)
    }

    wait(for: [viewExpectation], timeout: 1)
  }

  func testShowsProgressPresenter_whenChangeSortAndFilter_shouldNotifyInteractor() {
    // Given
    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
    setupPresenter(TraktLoginState.logged)
    presenter.viewDidLoad()

    // When
    presenter.changeSort(to: ShowProgressSort.releaseDate.index(), filter: ShowProgressFilter.watched.index())

    // Then
    let expectedListState = ShowProgressListState(sort: ShowProgressSort.releaseDate, filter: ShowProgressFilter.watched, direction: ShowProgressDirection.asc)
    XCTAssertEqual(expectedListState, interactor.listState)
  }

  //	func testShowsProgressPresenter_shouldPresentListAsSavedState() {
  //		//Given
  //		listStateDataSource.currentState = ShowProgressListState(sort: .releaseDate, filter: .returning, direction: .desc)
  //		interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, listStateDataSource: listStateDataSource, schedulers: TestSchedulers())
//
  //		let x = (interactor as! ShowsProgressMocks.ShowsProgressInteractorMock)
  //
//
  //		setupPresenter(TraktLoginState.logged)
//
  //		//When
  //		presenter.viewDidLoad()
//
  //		//
  //		XCTFail("Needs implementation")
  //	}
}
