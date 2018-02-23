import XCTest
@testable import CouchTrackerCore

final class ShowEpisodeDefaultPresenterTest: XCTestCase {
	private var view: ShowEpisodeMocks.View!
	private var router: ShowEpisodeMocks.Router!
	private var interactor: ShowEpisodeMocks.Interactor!
	private var presenter: ShowEpisodeDefaultPresenter!

	override func setUp() {
		super.setUp()

		presenter = nil
		view = nil
		interactor = nil
		router = nil

		view = ShowEpisodeMocks.View()
		interactor = ShowEpisodeMocks.Interactor()
		router = ShowEpisodeMocks.Router()
	}

	override func tearDown() {


		super.tearDown()
	}

	private func setupPresenter(_ show: WatchedShowEntity) {
		presenter = ShowEpisodeDefaultPresenter(view: view, interactor: interactor, router: router, show: show)
	}

	func testShowEpisodeDefaultPresenter_receivesShowWithoutNextEpisode_notifyViewIsEmpty() {
		//Given
		let show = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode()
		setupPresenter(show)

		//When
		presenter.viewDidLoad()

		//Then
		XCTAssertTrue(view.showEmptyViewInvoked)
		XCTAssertFalse(view.showViewModelInvoked)
		XCTAssertFalse(interactor.fetchImageURLInvoked)
		XCTAssertFalse(interactor.toogleWatchInvoked)
	}

	func testShowEpisodeDefaultPresenter_receivesShowWrongImageId_updateViewWithoutImage() {
		//Given
		let show = ShowsProgressMocks.mockWatchedShowEntity()
		setupPresenter(show)
		interactor.error = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 234, userInfo: nil)

		//When
		presenter.viewDidLoad()

		//Then
		XCTAssertTrue(view.showViewModelInvoked)
		XCTAssertTrue(interactor.fetchImageURLInvoked)
		XCTAssertFalse(view.showEpisodeImageInvoked)
	}

	func testShowEpisodeDefaultPresenter_receivesShow_updateViewAndImage() {
		//Given
		let show = ShowsProgressMocks.mockWatchedShowEntity()
		setupPresenter(show)

		//When
		presenter.viewDidLoad()

		//Then
		let testExpectation = expectation(description: "Should update view")

		DispatchQueue.main.async {
			testExpectation.fulfill()
			XCTAssertTrue(self.view.showViewModelInvoked)
			XCTAssertTrue(self.interactor.fetchImageURLInvoked)
			XCTAssertTrue(self.view.showEpisodeImageInvoked)
		}

		wait(for: [testExpectation], timeout: 1)
	}

	func testShowEpisodeDefaultPresenter_handleWatch_invokesInteractorAndUpdateView() {
		//Given
		let show = ShowsProgressMocks.mockWatchedShowEntity()
		setupPresenter(show)
		presenter.viewDidLoad()
		view.showViewModelInvoked = false
		view.showEmptyViewInvoked = false
		interactor.fetchImageURLInvoked = false
		interactor.toogleWatchInvoked = false

		//When
		presenter.handleWatch()

		//Then
		XCTAssertTrue(interactor.toogleWatchInvoked)
		XCTAssertTrue(interactor.fetchImageURLInvoked)
		XCTAssertTrue(view.showViewModelInvoked)
		XCTAssertTrue(view.showEpisodeImageInvoked)
	}

	//TODO needs implementation
//	func testShowEpisodeDefaultPresenter_handleWatchWithoutNextEpisode_showEmptyViewAndDoesNothing() {
//		//Given
//		let show = ShowsProgressMocks.mockWatchedShowEntity()
//		interactor.nextEntity = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode()
//		setupPresenter(show)
//		presenter.viewDidLoad()
//
//		self.presenter.handleWatch()
//
//		let testExpectation = expectation(description: "Should handle watch")
//
//		//When
//		DispatchQueue.main.async {
//			self.view.showViewModelInvoked = false
//			self.view.showEmptyViewInvoked = false
//			self.interactor.fetchImageURLInvoked = false
//			self.interactor.toogleWatchInvoked = false
//			self.presenter.handleWatch()
//			testExpectation.fulfill()
//		}
//
//		wait(for: [testExpectation], timeout: 10)
//
//		let testExpectation1 = self.expectation(description: "Should update view")
//
//		//Then
//		DispatchQueue.main.async {
//			XCTAssertTrue(self.view.showEmptyViewInvoked)
//			XCTAssertFalse(self.view.showViewModelInvoked)
//			XCTAssertFalse(self.interactor.fetchImageURLInvoked)
//			XCTAssertFalse(self.interactor.toogleWatchInvoked)
//			testExpectation1.fulfill()
//		}
//
//		self.wait(for: [testExpectation1], timeout: 10)
//	}

	func testShowEpisodeDefaultPresenter_handleWatchFail_notifyRouter() {
		//Given
		let show = ShowsProgressMocks.mockWatchedShowEntity()
		setupPresenter(show)
		interactor.toogleFailError = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 234, userInfo: nil)
		presenter.viewDidLoad()
		view.showViewModelInvoked = false
		view.showEmptyViewInvoked = false
		interactor.fetchImageURLInvoked = false
		interactor.toogleWatchInvoked = false

		//When
		presenter.handleWatch()

		//Then
		let testExpectation = expectation(description: "Should notify router")

		DispatchQueue.main.async {
			testExpectation.fulfill()
			XCTAssertTrue(self.interactor.toogleWatchInvoked)
			XCTAssertTrue(self.router.showErrorInvoked)
		}

		wait(for: [testExpectation], timeout: 1)
	}

	func testShowEpisodeDefaultPresenter_handleWatchError_notifyRouter() {
		//Given
		let show = ShowsProgressMocks.mockWatchedShowEntity()
		setupPresenter(show)
		interactor.error = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 234, userInfo: nil)
		presenter.viewDidLoad()
		view.showViewModelInvoked = false
		view.showEmptyViewInvoked = false
		interactor.fetchImageURLInvoked = false
		interactor.toogleWatchInvoked = false

		//When
		presenter.handleWatch()

		//Then
		let testExpectation = expectation(description: "Should notify router")

		DispatchQueue.main.async {
			testExpectation.fulfill()
			XCTAssertTrue(self.interactor.toogleWatchInvoked)
			XCTAssertTrue(self.router.showErrorInvoked)
		}

		wait(for: [testExpectation], timeout: 1)
	}
}
