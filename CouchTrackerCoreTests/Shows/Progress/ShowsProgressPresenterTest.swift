import XCTest
@testable import CouchTrackerCore

final class ShowsProgressDefaultPresenterTest: XCTestCase {
	private let view = ShowsProgressMocks.ShowsProgressViewMock()
	private let router = ShowsProgressMocks.ShowsProgressRouterMock()
	private let repository = ShowsProgressMocks.ShowsProgressRepositoryMock(trakt: traktProviderMock)
	private let dataSource = ShowsProgressMocks.ShowProgressViewDataSourceMock()

	func testShowsProgressPresenter_receivesEmptyData_notifyView() {
		//Given
		let loginState = TraktLoginState.logged
		let loginObservable = TraktLoginObservableMock(state: loginState)

		let interactor = ShowsProgressMocks.EmptyShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
		let presenter = ShowsProgressDefaultPresenter(view: view, interactor: interactor, viewDataSource: dataSource, router: router, loginObservable: loginObservable)

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
		let loginState = TraktLoginState.logged
		let loginObservable = TraktLoginObservableMock(state: loginState)

		let interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
		let presenter = ShowsProgressDefaultPresenter(view: view, interactor: interactor, viewDataSource: dataSource, router: router, loginObservable: loginObservable)

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
		let loginState = TraktLoginState.logged
		let loginObservable = TraktLoginObservableMock(state: loginState)

		let interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
		let presenter = ShowsProgressDefaultPresenter(view: view, interactor: interactor, viewDataSource: dataSource, router: router, loginObservable: loginObservable)
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
		let loginState = TraktLoginState.notLogged
		let loginObservable = TraktLoginObservableMock(state: loginState)

		let interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
		let presenter = ShowsProgressDefaultPresenter(view: view, interactor: interactor, viewDataSource: dataSource, router: router, loginObservable: loginObservable)

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
		let loginState = TraktLoginState.logged
		let loginObservable = TraktLoginObservableMock(state: loginState)

		let interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository, schedulers: TestSchedulers())
		let presenter = ShowsProgressDefaultPresenter(view: view, interactor: interactor, viewDataSource: dataSource, router: router, loginObservable: loginObservable)

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

		wait(for: [viewExpectation], timeout: 5)
	}
}
