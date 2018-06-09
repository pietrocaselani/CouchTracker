import XCTest
import RxTest
import RxSwift
import TraktSwift
@testable import CouchTrackerCore

final class MovieDetailsPresenterTest: XCTestCase {
	private var view: MovieDetailsViewMock!
	private var router: MovieDetailsRouterMock!
	private var genreRepository: GenreRepositoryMock!
	private var scheduler: TestScheduler!
	private var viewObserver: TestableObserver<MovieDetailsViewState>!
	private var imageObserver: TestableObserver<MovieDetailsImagesState>!
	private var disposeBag: DisposeBag!

	override func setUp() {
		super.setUp()

		view = MovieDetailsViewMock()
		router = MovieDetailsRouterMock()
		genreRepository = GenreRepositoryMock()
		scheduler = TestScheduler(initialClock: 0)
		disposeBag = DisposeBag()
		viewObserver = scheduler.createObserver(MovieDetailsViewState.self)
		imageObserver = scheduler.createObserver(MovieDetailsImagesState.self)
	}

	override func tearDown() {
		view = nil
		router = nil
		genreRepository = nil
		scheduler = nil
		viewObserver = nil
		imageObserver = nil
		disposeBag = nil

		super.tearDown()
	}

	func testMovieDetailsPresenter_fetchSuccess_andPresentMovieDetails() {
		let movie = TraktEntitiesMock.createMovieDetailsMock()
		let repository = MovieDetailsStoreMock(movie: movie)
		let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
																						imageRepository: imageRepositoryRealMock, movieIds: movie.ids)
		let presenter = MovieDetailsDefaultPresenter(view: view, interactor: interactor, router: router)

		presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

		presenter.viewDidLoad()

		let dateFormatter = TraktDateTransformer.dateTransformer.dateFormatter

		let genres = TraktEntitiesMock.createMoviesGenresMock()
		let movieGenres = genres.filter { movie.genres?.contains($0.slug) ?? false }.map { $0.name }

		let viewModel = MovieDetailsViewModel(
				title: movie.title ?? "TBA",
				tagline: movie.tagline ?? "",
				overview: movie.overview ?? "",
				genres: movieGenres.joined(separator: " | "),
				releaseDate: movie.released == nil ? "Unknown" : dateFormatter.string(from: movie.released!))

		let viewStateLoading = MovieDetailsViewState.loading
		let viewStateShowing = MovieDetailsViewState.showing(viewModel: viewModel)

		let expectedViewStateEvents = [next(0, viewStateLoading),
																																	next(0, viewStateShowing)]
		XCTAssertEqual(viewObserver.events, expectedViewStateEvents)

		XCTAssertTrue(view.invokedShow)
		XCTAssertEqual(view.invokedShowParameters?.details, viewModel)
	}

	func testMovieDetailsPresenter_fetchImagesSuccess_andNotifyView() {
		let movie = TraktEntitiesMock.createMovieMock(for: "the-dark-knight-2008")
		let repository = MovieDetailsStoreMock(movie: movie)
		let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
																						imageRepository: imageRepositoryRealMock, movieIds: movie.ids)
		let presenter = MovieDetailsDefaultPresenter(view: view, interactor: interactor, router: router)

		presenter.viewDidLoad()

		let posterLink = "https:/image.tmdb.org/t/p/w342/fpemzjF623QVTe98pCVlwwtFC5N.jpg"
		let backdropLink = "https:/image.tmdb.org/t/p/w300/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"
		let viewModel = ImagesViewModel(posterLink: posterLink, backdropLink: backdropLink)

		XCTAssertTrue(view.invokedShowImages)
		XCTAssertEqual(view.invokedShowImagesParameters?.images, viewModel)
	}

	func testMovieDetailsPresenter_fetchImagesFailure_andDontNotifyView() {
		let movie = TraktEntitiesMock.createMovieMock(for: "the-dark-knight-2008")
		let repository = MovieDetailsStoreMock(movie: movie)

		let json = "{\"trakt\": 4,\"slug\": \"the-dark-knight-2008\",\"imdb\": \"tt0468569\",\"tmdb\": null}".data(using: .utf8)!

		let movieIds = try! JSONDecoder().decode(MovieIds.self, from: json)

		let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
																						imageRepository: imageRepositoryRealMock, movieIds: movieIds)
		let presenter = MovieDetailsDefaultPresenter(view: view, interactor: interactor, router: router)

		presenter.viewDidLoad()

		XCTAssertFalse(view.invokedShowImages)
	}

	func testMovieDetailsPresenter_fetchFailure_andPresentErrorMessage() {
		let movie = TraktEntitiesMock.createMovieDetailsMock()
		let errorMessage = "There is no active connection"
		let detailsError = MovieDetailsError.noConnection(errorMessage)
		let repository = ErrorMovieDetailsStoreMock(error: detailsError)
		let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
																						imageRepository: imageRepositoryMock, movieIds: movie.ids)
		let presenter = MovieDetailsDefaultPresenter(view: view, interactor: interactor, router: router)

		presenter.viewDidLoad()

		XCTAssertTrue(router.invokedShowError)
		XCTAssertEqual(router.invokedShowErrorParameters?.message, errorMessage)
	}

	func testMovieDetailsPresenter_fetchFailure_andIsCustomError() {
		let movie = TraktEntitiesMock.createMovieDetailsMock()
		let errorMessage = "Custom details error"
		let error = NSError(domain: "io.github.pietrocaselani.CouchTracker", code: 10, userInfo: [NSLocalizedDescriptionKey: errorMessage])
		let repository = ErrorMovieDetailsStoreMock(error: error)
		let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
																						imageRepository: imageRepositoryMock, movieIds: movie.ids)
		let presenter = MovieDetailsDefaultPresenter(view: view, interactor: interactor, router: router)

		presenter.viewDidLoad()

		XCTAssertTrue(router.invokedShowError)
		XCTAssertEqual(router.invokedShowErrorParameters?.message, errorMessage)
	}
}
