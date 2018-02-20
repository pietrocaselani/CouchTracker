import XCTest
import RxSwift
import RxTest
import TraktSwift

final class TrendingInteractorTest: XCTestCase {

	private let scheduler = TestScheduler(initialClock: 0)
	private var moviesObserver: TestableObserver<[TrendingMovieEntity]>!
	private var showsObserver: TestableObserver<[TrendingShowEntity]>!

	private var disposeBag: DisposeBag!

	override func setUp() {
		super.setUp()

		moviesObserver = scheduler.createObserver([TrendingMovieEntity].self)
		showsObserver = scheduler.createObserver([TrendingShowEntity].self)
		disposeBag = DisposeBag()
	}

	override func tearDown() {
		moviesObserver = nil
		showsObserver = nil
		disposeBag = nil
		super.tearDown()
	}

	func testTrendingInteractor_fetchMoviesSuccessReceivesNoData_emitsEmptyDataAndCompleted() {
		let repository = EmptyTrendingRepositoryMock()
		let imageRepository = EmptyImageRepositoryMock(tmdb: tmdbProviderMock,
																									tvdb: tvdbProviderMock,
																									cofigurationRepository: configurationRepositoryMock)
		let interactor = TrendingService(repository: repository, imageRepository: imageRepository)

		let subscription = interactor.fetchMovies(page: 0, limit: 10).subscribe(moviesObserver)
		subscription.disposed(by: disposeBag)

		scheduler.start()

		let events: [Recorded<Event<[TrendingMovieEntity]>>] = [next(0, [TrendingMovieEntity]()), completed(0)]

		RXAssertEvents(moviesObserver, events)
	}

	func testTrendingInteractor_fetchShowsSuccessReceivesNoData_emitsOnlyCompleted() {
		let repository = EmptyTrendingRepositoryMock()
		let imageRepository = EmptyImageRepositoryMock(tmdb: tmdbProviderMock,
																									tvdb: tvdbProviderMock,
																									cofigurationRepository: configurationRepositoryMock)
		let interactor = TrendingService(repository: repository, imageRepository: imageRepository)

		let subscription = interactor.fetchShows(page: 0, limit: 10).subscribe(showsObserver)
		subscription.disposed(by: disposeBag)

		scheduler.start()

		let events: [Recorded<Event<[TrendingShowEntity]>>] = [next(0, [TrendingShowEntity]()), completed(0)]

		RXAssertEvents(showsObserver, events)
	}

	func testTrendingInteractor_fetchMoviesFailure_emitsOnlyError() {
		let connectionError = TrendingError.noConnection("There is no connection active")

		let repository = ErrorTrendingRepositoryMock(error: connectionError)
		let interactor = TrendingService(repository: repository, imageRepository: imageRepositoryMock)

		let subscription = interactor.fetchMovies(page: 0, limit: 10).subscribe(moviesObserver)

		scheduler.scheduleAt(600) {
			subscription.dispose()
		}

		scheduler.start()

		let events: [Recorded<Event<[TrendingMovieEntity]>>] = [error(0, connectionError)]

		RXAssertEvents(moviesObserver, events)
	}

	func testTrendingInteractor_fetchShowsFailure_emitsOnlyError() {
		let connectionError = TrendingError.noConnection("There is no connection active")

		let repository = ErrorTrendingRepositoryMock(error: connectionError)
		let interactor = TrendingService(repository: repository, imageRepository: imageRepositoryMock)

		let subscription = interactor.fetchShows(page: 0, limit: 10).subscribe(showsObserver)

		scheduler.scheduleAt(600) {
			subscription.dispose()
		}

		scheduler.start()

		let events: [Recorded<Event<[TrendingShowEntity]>>] = [error(0, connectionError)]

		RXAssertEvents(showsObserver, events)
	}

	func testTrendingInteractor_fetchMoviesSuccessReceivesData_emitsEntitiesAndCompleted() {
		let movies = TraktEntitiesMock.createMockMovies()

		let repository = TrendingMoviesRepositoryMock(movies: movies)
		let interactor = TrendingService(repository: repository, imageRepository: imageRepositoryRealMock)

		let subscription = interactor.fetchMovies(page: 0, limit: 10).subscribe(moviesObserver)

		scheduler.scheduleAt(600) {
			subscription.dispose()
		}

		scheduler.start()

		let expectedMovies = movies.map { trendingMovie -> TrendingMovieEntity in
			return MovieEntityMapper.entity(for: trendingMovie)
		}

		let events: [Recorded<Event<[TrendingMovieEntity]>>] = [next(0, expectedMovies), completed(0)]

		RXAssertEvents(moviesObserver, events)
	}

	func testTrendingInteractor_fetchShowsSuccessReceivesData_emitsEntitiesAndCompleted() {
		let repository = trendingRepositoryMock
		let interactor = TrendingService(repository: repository, imageRepository: imageRepositoryRealMock)

		let subscription = interactor.fetchShows(page: 0, limit: 10).subscribe(showsObserver)

		scheduler.scheduleAt(600) {
			subscription.dispose()
		}

		scheduler.start()

		let expectedShows = TraktEntitiesMock.createTrendingShowsMock().map { ShowEntityMapper.entity(for: $0) }

		let events: [Recorded<Event<[TrendingShowEntity]>>] = [next(0, expectedShows), completed(0)]

		RXAssertEvents(showsObserver, events)
	}
}
