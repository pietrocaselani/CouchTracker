import XCTest
@testable import CouchTrackerCore

final class ShowsProgressDefaultPresenterTest: XCTestCase {
	private let view = ShowsProgressMocks.ShowsProgressViewMock()
	private let router = ShowsProgressMocks.ShowsProgressRouterMock()
	private let repository = ShowsProgressMocks.ShowsProgressRepositoryMock(trakt: createTraktProviderMock())
	private let dataSource = ShowsProgressMocks.ShowProgressViewDataSourceMock()
	private var interactor: ShowsProgressInteractor!
	private var presenter: ShowsProgressDefaultPresenter!
	private var loginObservable: TraktLoginObservableMock!

	private func setupPresenter(_ loginState: TraktLoginState) {
		loginObservable = TraktLoginObservableMock(state: loginState)

		presenter = ShowsProgressDefaultPresenter(view: view, interactor: interactor, viewDataSource: dataSource, router: router, loginObservable: loginObservable)
	}

	func testShowsProgressPresenter_receivesEmptyData_notifyView() {
		//Given
		interactor = ShowsProgressMocks.EmptyShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
		setupPresenter(TraktLoginState.logged)

		//When
		presenter.viewDidLoad()

		//Then
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
		//Given
		interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
		setupPresenter(TraktLoginState.logged)

		//When
		presenter.viewDidLoad()

		//Then
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
		//Given
		interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
		setupPresenter(TraktLoginState.logged)
		presenter.viewDidLoad()

		//When
		presenter.updateShows()

		//Then
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
		//Given
		interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
		setupPresenter(TraktLoginState.notLogged)

		//When
		presenter.viewDidLoad()

		//Then
		XCTAssertTrue(view.showErrorInvoked)
		XCTAssertEqual(view.showErrorParameters, "You need to login on Trakt to access this content")
		XCTAssertFalse(view.showViewModelsInvoked)
		XCTAssertFalse(view.showEmptyViewInvoked)
		XCTAssertFalse(view.showLoadingInvoked)
	}

	func testShowsProgressPresenter_receivesNotLoggedEvent_updateView() {
		//Given
		interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
		setupPresenter(TraktLoginState.logged)

		presenter.viewDidLoad()

		//When
		loginObservable.changeTo(state: TraktLoginState.notLogged)

		//Then
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
		//Given
		interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
		setupPresenter(TraktLoginState.logged)
		presenter.viewDidLoad()

		//When
		presenter.handleFilter()

		//Then
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

		wait(for: [testExpectation], timeout: 4)
	}
}
