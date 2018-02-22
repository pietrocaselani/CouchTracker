import XCTest
@testable import CouchTrackerCore

final class ShowProgressCellDefaultPresenterTest: XCTestCase {
	private var view: ShowProgressCellMocks.View!
	private var interactor: ShowProgressCellMocks.Interactor!

	override func setUp() {
		super.setUp()

		view = ShowProgressCellMocks.View()
		interactor = ShowProgressCellMocks.Interactor(imageRepository: ImagesRepositorySampleMock())
	}

	func testShowProgressCellDefaultPresenter_receivesViewModelWithoutTMDBId_sendViewModelToView() {
		//Given
		let viewModel = WatchedShowViewModel(title: "Title", nextEpisode: nil, nextEpisodeDate: nil, status: "Returning", tmdbId: nil)

		let presenter = ShowProgressCellDefaultPresenter(view: view, interactor: interactor, viewModel: viewModel)

		//When
		presenter.viewWillAppear()

		//Then
		guard let receivedViewModel = view.showViewModelParameters else {
			XCTFail()
			return
		}
		XCTAssertTrue(view.showViewModelInvoked)
		XCTAssertFalse(view.showPosterImageInvoked)
		XCTAssertEqual(receivedViewModel, viewModel)
		XCTAssertFalse(interactor.fetchPosterImageURLInvoked)
	}

	func testShowProgressCellDefaultPresenter_receivesViewModelWithTMDBId_sendViewModelAndImageToView() {
		//Given
		let viewModel = WatchedShowViewModel(title: "Title", nextEpisode: nil, nextEpisodeDate: nil, status: "Returning", tmdbId: 1010)

		let presenter = ShowProgressCellDefaultPresenter(view: view, interactor: interactor, viewModel: viewModel)

		//When
		presenter.viewWillAppear()

		//Then
		guard let receivedViewModel = view.showViewModelParameters else {
			XCTFail()
			return
		}

		guard let receivedURL = view.showPosterImageParameters else {
			XCTFail()
			return
		}

		let expectedURL = URL(fileURLWithPath: "fake/path/image.png")

		XCTAssertTrue(view.showViewModelInvoked)
		XCTAssertTrue(view.showPosterImageInvoked)
		XCTAssertEqual(receivedViewModel, viewModel)
		XCTAssertEqual(receivedURL, expectedURL)
		XCTAssertTrue(interactor.fetchPosterImageURLInvoked)
	}

	func testShowProgressCellDefaultPresenter_receivesErrorFromInteractor_doestNotifyView() {
		//Given
		let viewModel = WatchedShowViewModel(title: "Title", nextEpisode: nil, nextEpisodeDate: nil, status: "Returning", tmdbId: 1010)
		let error = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 132, userInfo: nil)
		interactor.imageError = error

		let presenter = ShowProgressCellDefaultPresenter(view: view, interactor: interactor, viewModel: viewModel)

		//When
		presenter.viewWillAppear()

		//Then
		guard let receivedViewModel = view.showViewModelParameters else {
			XCTFail()
			return
		}

		XCTAssertTrue(view.showViewModelInvoked)
		XCTAssertFalse(view.showPosterImageInvoked)
		XCTAssertEqual(receivedViewModel, viewModel)
		XCTAssertTrue(interactor.fetchPosterImageURLInvoked)
	}
}
