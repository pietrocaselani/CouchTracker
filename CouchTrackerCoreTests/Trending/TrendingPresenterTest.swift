import Moya
import XCTest
import TraktSwift
import RxTest
@testable import CouchTrackerCore

final class TrendingPresenterTest: XCTestCase {

	private let scheduler = TestScheduler(initialClock: 0)
	let view = TrendingViewMock()
	let router = TrendingRouterMock()
	let dataSource = TrendingDataSourceMock()

	func testTrendingPresenter_fetchMoviesSuccessWithEmptyData_andPresentNothing() {
		let repository = EmptyTrendingRepositoryMock()
		let interactor = TrendingServiceMock(repository: repository, imageRepository: imageRepositoryMock)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .movies)

		presenter.viewDidLoad()

		XCTAssertTrue(view.invokedShowEmptyView)
		XCTAssertFalse(view.invokedShow)
	}

	func testTrendingPresenter_fetchShowsSuccessWithEmptyData_andPresentNothing() {
		let repository = EmptyTrendingRepositoryMock()
		let interactor = TrendingServiceMock(repository: repository, imageRepository: imageRepositoryMock)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .shows)

		presenter.viewDidLoad()

		XCTAssertTrue(view.invokedShowEmptyView)
		XCTAssertFalse(view.invokedShow)
		XCTAssertFalse(dataSource.invokedSetViewModels)
		XCTAssertTrue(dataSource.viewModels.isEmpty)
	}

	func testTrendingPresenter_fetchMoviesFailure_andPresentError() {
		let error = TrendingError.parseError("Invalid json")
		let repository = ErrorTrendingRepositoryMock(error: error)
		let interactor = TrendingServiceMock(repository: repository, imageRepository: imageRepositoryMock)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .movies)

		presenter.viewDidLoad()

		XCTAssertTrue(router.invokedShowError)
		XCTAssertEqual(router.invokedShowErrorParameters?.message, "Invalid json")
	}

	func testTrendingPresenter_fetchShowsFailure_andPresentError() {
		let error = TrendingError.parseError("Invalid json")
		let repository = ErrorTrendingRepositoryMock(error: error)
		let interactor = TrendingServiceMock(repository: repository, imageRepository: imageRepositoryMock)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .shows)

		presenter.viewDidLoad()

		XCTAssertTrue(router.invokedShowError)
		XCTAssertEqual(router.invokedShowErrorParameters?.message, "Invalid json")
	}

	func testTrendingPresenter_fetchMoviesSuccess_andPresentMovies() {
		let movies = TraktEntitiesMock.createMockMovies()
		let images = TMDBEntitiesMock.createImagesEntityMock()
		let repository = TrendingMoviesRepositoryMock(movies: movies)
		let interactor = TrendingServiceMock(repository: repository, imageRepository: createMovieImagesRepositoryMock(images))
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .movies)

		presenter.viewDidLoad()

		let expectedViewModel = movies.map { trendingMovie -> TrendingViewModel in
			let type = trendingMovie.movie.ids.tmdbModelType()
			return TrendingViewModel(title: trendingMovie.movie.title ?? "TBA", type: type)
		}

		XCTAssertTrue(view.invokedShow)
		XCTAssertTrue(dataSource.invokedSetViewModels)
		XCTAssertEqual(dataSource.viewModels, expectedViewModel)
	}

	func testTrendingPresenter_fetchShowsSuccess_andPresentShows() {
		let images = TMDBEntitiesMock.createImagesEntityMock()
		let imagesRepository = createMovieImagesRepositoryMock(images)
		let interactor = TrendingServiceMock(repository: trendingRepositoryMock, imageRepository: imagesRepository)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .shows)

		presenter.viewDidLoad()

		XCTAssertTrue(view.invokedShow)
	}

	func testTrendingPresenter_fetchMoviewSuccess_andPresentNoMovies() {
		let movies = [TrendingMovie]()
		let images = TMDBEntitiesMock.createImagesEntityMock()
		let repository = TrendingMoviesRepositoryMock(movies: movies)
		let interactor = TrendingServiceMock(repository: repository, imageRepository: createMovieImagesRepositoryMock(images))

		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .movies)

		presenter.viewDidLoad()

		XCTAssertTrue(view.invokedShowEmptyView)
		XCTAssertFalse(view.invokedShow)
	}

	func testTrendingPresenter_fetchMoviesFailure_andIsCustomError() {
		let userInfo = [NSLocalizedDescriptionKey: "Custom list movies error"]
		let error = NSError(domain: "io.github.pietrocaselani.CouchTracker", code: 10, userInfo: userInfo)
		let interactor = TrendingServiceMock(repository: ErrorTrendingRepositoryMock(error: error), imageRepository: imageRepositoryMock)

		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .movies)

		presenter.viewDidLoad()

		XCTAssertTrue(router.invokedShowError)
		XCTAssertEqual(router.invokedShowErrorParameters?.message, "Custom list movies error")
	}

	func testTrendingPresenter_requestToShowDetailsOfMovie_notifyRouterToShowDetails() {
		let movieIndex = 1
		let movies = TraktEntitiesMock.createMockMovies()
		let images = TMDBEntitiesMock.createImagesEntityMock()
		let repository = TrendingMoviesRepositoryMock(movies: movies)
		let interactor = TrendingServiceMock(repository: repository, imageRepository: createMovieImagesRepositoryMock(images))
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .movies)

		presenter.viewDidLoad()
		presenter.showDetailsOfTrending(at: movieIndex)

		let expectedMovie = MovieEntityMapper.entity(for: movies[movieIndex].movie)

		XCTAssertTrue(router.invokedMovieDetails)
		XCTAssertEqual(router.invokedMovieDetailsParameters?.movie, expectedMovie)
	}

	func testTrendingPresenter_requestToShowDetailsOfShow_notifyRouterToShowDetails() {
		let showIndex = 1
		let shows = TraktEntitiesMock.createTrendingShowsMock()
		let images = TMDBEntitiesMock.createImagesEntityMock()
		let repository = TrendingShowsRepositoryMock(shows: shows)
		let interactor = TrendingServiceMock(repository: repository, imageRepository: createMovieImagesRepositoryMock(images))
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .shows)

		presenter.viewDidLoad()
		presenter.showDetailsOfTrending(at: 1)

		let expectedShow = ShowEntityMapper.entity(for: shows[showIndex].show)

		XCTAssertTrue(router.invokedShowDetails)
		XCTAssertEqual(router.invokedShowDetailsParameters?.show, expectedShow)
	}
}
