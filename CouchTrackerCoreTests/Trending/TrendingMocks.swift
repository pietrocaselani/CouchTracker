import Foundation
import RxSwift
import TraktSwift
@testable import CouchTrackerCore

let trendingRepositoryMock = TrendingRepositoryMock(traktProvider: createTraktProviderMock())

final class TrendingViewMock: TrendingView {
	var appConfigurationsPresentable: AppConfigurationsPresentable!
	var presenter: TrendingPresenter!
	var searchView: SearchView!
	var invokedShowEmptyView = false

	func showEmptyView() {
		invokedShowEmptyView = true
	}

	var invokedShow = false

	func showTrendingsView() {
		invokedShow = true
	}
}

final class TrendingPresenterMock: TrendingPresenter {
	let currentTrendingType = Variable<TrendingType>(.movies)
	var dataSource: TrendingDataSource
	var invokedViewDidLoad = false
	var type: TrendingType

	init(view: TrendingView, interactor: TrendingInteractor, router: TrendingRouter,
	     dataSource: TrendingDataSource, type: TrendingType) {
		self.dataSource = dataSource
		self.type = type
	}

	func viewDidLoad() {
		invokedViewDidLoad = true
	}

	var invokedShowDetailsOfTrending = false
	var invokedShowDetailsOfTrendingParameters: (index: Int, Void)?

	func showDetailsOfTrending(at index: Int) {
		invokedShowDetailsOfTrending = true
		invokedShowDetailsOfTrendingParameters = (index, ())
	}
}

final class TrendingRouterMock: TrendingRouter, AppConfigurationsPresentable {
	var invokedMovieDetails = false
	var invokedMovieDetailsParameters: (movie: MovieEntity, Void)?

	func showDetails(of movie: MovieEntity) {
		invokedMovieDetails = true
		invokedMovieDetailsParameters = (movie, ())
	}

	var invokedShowDetails = false
	var invokedShowDetailsParameters: (show: ShowEntity, Void)?

	func showDetails(of show: ShowEntity) {
		invokedShowDetails = true
		invokedShowDetailsParameters = (show, ())
	}

	var invokedShowError = false
	var invokedShowErrorParameters: (message: String, Void)?

	func showError(message: String) {
		invokedShowError = true
		invokedShowErrorParameters = (message, ())
	}

	var invokedShowAppSettings = false

	func showAppSettings() {
		invokedShowAppSettings = true
	}
}

final class EmptyTrendingRepositoryMock: TrendingRepository {
	func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
		return Observable.just([TrendingMovie]())
	}

	func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
		return Observable.just([TrendingShow]())
	}
}

final class ErrorTrendingRepositoryMock: TrendingRepository {
	private let error: Error

	init(error: Error) {
		self.error = error
	}

	func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
		return Observable.error(error)
	}

	func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
		return Observable.error(error)
	}
}

final class TrendingMoviesRepositoryMock: TrendingRepository {
	private let movies: [TrendingMovie]

	init(movies: [TrendingMovie]) {
		self.movies = movies
	}

	func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
		return Observable.just(movies).take(limit)
	}

	func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
		return Observable.empty()
	}
}

final class TrendingShowsRepositoryMock: TrendingRepository {
	private let shows: [TrendingShow]

	init(shows: [TrendingShow]) {
		self.shows = shows
	}

	func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
		return Observable.empty()
	}

	func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
		return Observable.just(shows).take(limit)
	}
}

final class TrendingRepositoryMock: TrendingRepository {
	private let traktProvider: TraktProvider

	init(traktProvider: TraktProvider) {
		self.traktProvider = traktProvider
	}

	func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
		return traktProvider.movies.rx.request(.trending(page: page, limit: limit, extended: .full))
				.map([TrendingMovie].self).asObservable()
	}

	func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
		return traktProvider.shows.rx.request(.trending(page: page, limit: limit, extended: .full))
				.map([TrendingShow].self).asObservable()
	}
}

final class TrendingServiceMock: TrendingInteractor {
	let trendingRepo: TrendingRepository

	init(repository: TrendingRepository) {
		self.trendingRepo = repository
	}

	func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovieEntity]> {
		let moviesObservable = trendingRepo.fetchMovies(page: page, limit: limit)

		return moviesObservable.map {
			$0.map {
				MovieEntityMapper.entity(for: $0)
			}
		}
	}

	func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShowEntity]> {
		return trendingRepo.fetchShows(page: page, limit: limit).map {
			return $0.map {
				ShowEntityMapper.entity(for: $0)
			}
		}
	}
}

final class TrendingDataSourceMock: TrendingDataSource {
	var invokedSetViewModels = false

	var viewModels = [PosterViewModel]() {
		didSet {
			invokedSetViewModels = true
		}
	}
}
