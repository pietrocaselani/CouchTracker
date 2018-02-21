import XCTest
import TraktSwift
@testable import CouchTrackerCore

final class MovieDetailsPresenterTest: XCTestCase {

	let view = MovieDetailsViewMock()
	let router = MovieDetailsRouterMock()
	let genreRepository = GenreRepositoryMock()

	func testMovieDetailsPresenter_fetchSuccess_andPresentMovieDetails() {
		let movie = TraktEntitiesMock.createMovieDetailsMock()
		let repository = MovieDetailsStoreMock(movie: movie)
		let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
																						imageRepository: imageRepositoryRealMock, movieIds: movie.ids)
		let presenter = MovieDetailsiOSPresenter(view: view, interactor: interactor, router: router)

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

		XCTAssertTrue(view.invokedShow)
		XCTAssertEqual(view.invokedShowParameters?.details, viewModel)
	}

	func testMovieDetailsPresenter_fetchImagesSuccess_andNotifyView() {
		let movie = TraktEntitiesMock.createMovieMock(for: "the-dark-knight-2008")
		let repository = MovieDetailsStoreMock(movie: movie)
		let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
																						imageRepository: imageRepositoryRealMock, movieIds: movie.ids)
		let presenter = MovieDetailsiOSPresenter(view: view, interactor: interactor, router: router)

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
		let presenter = MovieDetailsiOSPresenter(view: view, interactor: interactor, router: router)

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
		let presenter = MovieDetailsiOSPresenter(view: view, interactor: interactor, router: router)

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
		let presenter = MovieDetailsiOSPresenter(view: view, interactor: interactor, router: router)

		presenter.viewDidLoad()

		XCTAssertTrue(router.invokedShowError)
		XCTAssertEqual(router.invokedShowErrorParameters?.message, errorMessage)
	}
}
