import XCTest
import RxTest
import RxSwift
import TraktSwift
@testable import CouchTrackerCore

final class MovieDetailsAPIRepositoryTests: XCTestCase {
	private var schedulers: TestSchedulers!
	private var disposeBag: DisposeBag!

	override func setUp() {
		super.setUp()

		schedulers = TestSchedulers()
		disposeBag = DisposeBag()
	}

	override func tearDown() {
		schedulers = nil
		disposeBag = nil

		super.tearDown()
	}

	func testMovieDetailsRepository_addMovieToHistory_shouldInvokeTrakt() {
		//Given
		let trakt = createTraktProviderMock()
		let repository = MovieDetailsAPIRepository(traktProvider: trakt, schedulers: schedulers)
		let movie = MovieEntityMapper.entity(for: TraktEntitiesMock.createMovieDetailsMock())
		let observer = schedulers.createObserver(SyncMovieResult.self)

		//When
		repository.addToHistory(movie: movie).asObservable().subscribe(observer).disposed(by: disposeBag)

		//Then
		let expectedEvents = [Recorded.next(0, SyncMovieResult.success), Recorded.completed(0)]
		let items = SyncItems(movies: [SyncMovie(ids: movie.ids)])
		let provider = trakt.sync as! MoyaProviderMock

		XCTAssertEqual(provider.requestInvokedCount, 1)
		XCTAssertEqual(provider.targetInvoked, Sync.addToHistory(items: items))
		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testMovieDetailsRepository_removeMovieFromHistory_shouldInvokeTrakt() {
		//Given
		let trakt = createTraktProviderMock()
		let repository = MovieDetailsAPIRepository(traktProvider: trakt, schedulers: schedulers)
		let movie = MovieEntityMapper.entity(for: TraktEntitiesMock.createMovieDetailsMock())
		let observer = schedulers.createObserver(SyncMovieResult.self)

		//When
		repository.removeFromHistory(movie: movie).asObservable().subscribe(observer).disposed(by: disposeBag)

		//Then
		let expectedEvents = [Recorded.next(0, SyncMovieResult.success), Recorded.completed(0)]
		let items = SyncItems(movies: [SyncMovie(ids: movie.ids)])
		let provider = trakt.sync as! MoyaProviderMock

		XCTAssertEqual(provider.requestInvokedCount, 1)
		XCTAssertEqual(provider.targetInvoked, Sync.removeFromHistory(items: items))
		XCTAssertEqual(observer.events, expectedEvents)
	}
}
