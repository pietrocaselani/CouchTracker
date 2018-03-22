import XCTest
@testable import CouchTrackerCore

final class PosterCellPresenterTest: XCTestCase {

	private let view = PosterCellViewMock()

	func testTrendingCellPresenter_updatesViewModelOnView() {
		let interactor = TrendingCellInteractorMock(imageRepository: imageRepositoryRealMock)
		let trendingViewModel = PosterViewModel(title: "Nice", type: nil)
		let presenter = PosterCellDefaultPresenter(view: view, interactor: interactor, viewModel: trendingViewModel)

		presenter.viewWillAppear()

		let expectedCellViewModel = PosterCellViewModel(title: "Nice")

		XCTAssertTrue(view.invokedShowViewModel)
		XCTAssertEqual(view.invokedShowViewModelParameters!.viewModel, expectedCellViewModel)
	}

	func testTrendingCellPresenter_receivesImageURL_notifyView() {
		let interactor = TrendingCellInteractorMock(imageRepository: imageRepositoryRealMock)

		let type = PosterViewModelType.movie(tmdbMovieId: 4)

		let trendingViewModel = PosterViewModel(title: "Nice", type: type)
		let presenter = PosterCellDefaultPresenter(view: view, interactor: interactor, viewModel: trendingViewModel)

		presenter.viewWillAppear()

		let expectedURL = URL(string: "https:/image.tmdb.org/t/p/w185/fpemzjF623QVTe98pCVlwwtFC5N.jpg")!

		let realURL = view.invokedPosterImageParameters?.url ?? URL(string: "https://fake.url")!

		XCTAssertTrue(view.invokedShowPosterImage)
		XCTAssertEqual(realURL, expectedURL)
	}
}
