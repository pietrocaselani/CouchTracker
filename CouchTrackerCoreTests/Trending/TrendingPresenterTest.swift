import Moya
import XCTest
import TraktSwift
import RxTest
@testable import CouchTrackerCore

final class TrendingPresenterTest: XCTestCase {

	private var schedulers: TestSchedulers!
	private var view: TrendingViewMock!
	private var router: TrendingRouterMock!
	private var dataSource: TrendingDataSourceMock!

	override func setUp() {
		super.setUp()

		schedulers = TestSchedulers(initialClock: 0)
		view = TrendingViewMock()
		router = TrendingRouterMock()
		dataSource = TrendingDataSourceMock()
	}

	override func tearDown() {
		schedulers = nil
		view = nil
		router = nil
		dataSource = nil

		super.tearDown()
	}

	func testTrendingPresenter_fetchMoviesSuccessWithEmptyData_andPresentNothing() {
		let repository = EmptyTrendingRepositoryMock()
		let interactor = TrendingServiceMock(repository: repository)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .movies, schedulers: schedulers)

		presenter.viewDidLoad()
		schedulers.start()

		XCTAssertTrue(view.invokedShowEmptyView)
		XCTAssertFalse(view.invokedShow)
	}

	func testTrendingPresenter_fetchShowsSuccessWithEmptyData_andPresentNothing() {
		let repository = EmptyTrendingRepositoryMock()
		let interactor = TrendingServiceMock(repository: repository)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .shows, schedulers: schedulers)

		presenter.viewDidLoad()
		schedulers.start()

		XCTAssertTrue(view.invokedShowEmptyView)
		XCTAssertFalse(view.invokedShow)
		XCTAssertFalse(dataSource.invokedSetViewModels)
		XCTAssertTrue(dataSource.viewModels.isEmpty)
	}

	func testTrendingPresenter_fetchMoviesFailure_andPresentError() {
		let error = TrendingError.parseError("Invalid json")
		let repository = ErrorTrendingRepositoryMock(error: error)
		let interactor = TrendingServiceMock(repository: repository)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .movies, schedulers: schedulers)

		presenter.viewDidLoad()
		schedulers.start()

		XCTAssertTrue(router.invokedShowError)
		XCTAssertEqual(router.invokedShowErrorParameters?.message, "Invalid json")
	}

	func testTrendingPresenter_fetchShowsFailure_andPresentError() {
		let error = TrendingError.parseError("Invalid json")
		let repository = ErrorTrendingRepositoryMock(error: error)
		let interactor = TrendingServiceMock(repository: repository)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .shows, schedulers: schedulers)

		presenter.viewDidLoad()
		schedulers.start()

		XCTAssertTrue(router.invokedShowError)
		XCTAssertEqual(router.invokedShowErrorParameters?.message, "Invalid json")
	}

	func testTrendingPresenter_fetchMoviesSuccess_andPresentMovies() {
		let movies = TraktEntitiesMock.createMockMovies()
		let repository = TrendingMoviesRepositoryMock(movies: movies)
		let interactor = TrendingServiceMock(repository: repository)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .movies, schedulers: schedulers)

		presenter.viewDidLoad()
		schedulers.start()

		let expectedViewModel = movies.map { trendingMovie -> PosterViewModel in
			let type = trendingMovie.movie.ids.tmdbModelType()
			return PosterViewModel(title: trendingMovie.movie.title ?? "TBA", type: type)
		}

		XCTAssertTrue(view.invokedShow)
		XCTAssertTrue(dataSource.invokedSetViewModels)
		XCTAssertEqual(dataSource.viewModels, expectedViewModel)
	}

	func testTrendingPresenter_fetchShowsSuccess_andPresentShows() {
		let interactor = TrendingServiceMock(repository: trendingRepositoryMock)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .shows, schedulers: schedulers)

		presenter.viewDidLoad()
		schedulers.start()

		XCTAssertTrue(view.invokedShow)
	}

	func testTrendingPresenter_fetchMoviewSuccess_andPresentNoMovies() {
		let movies = [TrendingMovie]()
		let repository = TrendingMoviesRepositoryMock(movies: movies)
		let interactor = TrendingServiceMock(repository: repository)

		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .movies, schedulers: schedulers)

		presenter.viewDidLoad()
		schedulers.start()

		XCTAssertTrue(view.invokedShowEmptyView)
		XCTAssertFalse(view.invokedShow)
	}

	func testTrendingPresenter_fetchMoviesFailure_andIsCustomError() {
		let userInfo = [NSLocalizedDescriptionKey: "Custom list movies error"]
		let error = NSError(domain: "io.github.pietrocaselani.CouchTracker", code: 10, userInfo: userInfo)
		let interactor = TrendingServiceMock(repository: ErrorTrendingRepositoryMock(error: error))

		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .movies, schedulers: schedulers)

		presenter.viewDidLoad()
		schedulers.start()

		XCTAssertTrue(router.invokedShowError)
		XCTAssertEqual(router.invokedShowErrorParameters?.message, "Custom list movies error")
	}

	func testTrendingPresenter_requestToShowDetailsOfMovie_notifyRouterToShowDetails() {
		let movieIndex = 1
		let movies = TraktEntitiesMock.createMockMovies()
		let repository = TrendingMoviesRepositoryMock(movies: movies)
		let interactor = TrendingServiceMock(repository: repository)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .movies, schedulers: schedulers)
		presenter.viewDidLoad()
		schedulers.start()

		presenter.showDetailsOfTrending(at: movieIndex)

		let expectedMovie = MovieEntityMapper.entity(for: movies[movieIndex].movie)

		XCTAssertTrue(router.invokedMovieDetails)
		XCTAssertEqual(router.invokedMovieDetailsParameters?.movie, expectedMovie)
	}

	func testTrendingPresenter_requestToShowDetailsOfShow_notifyRouterToShowDetails() {
		let showIndex = 1
		let shows = TraktEntitiesMock.createTrendingShowsMock()
		let repository = TrendingShowsRepositoryMock(shows: shows)
		let interactor = TrendingServiceMock(repository: repository)
		let presenter = TrendingDefaultPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource, type: .shows, schedulers: schedulers)
		presenter.viewDidLoad()
		schedulers.start()
		
		presenter.showDetailsOfTrending(at: 1)

		let expectedShow = ShowEntityMapper.entity(for: shows[showIndex].show)

		XCTAssertTrue(router.invokedShowDetails)
		XCTAssertEqual(router.invokedShowDetailsParameters?.show, expectedShow)
	}
}
