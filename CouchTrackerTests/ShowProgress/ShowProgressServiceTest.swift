import XCTest
import RxTest
import TraktSwift

final class ShowProgressServiceTest: XCTestCase {
	private let scheduler = TestScheduler(initialClock: 0)
	private var interactor: ShowProgressService!
	private var observer: TestableObserver<WatchedShowBuilder>!

	override func setUp() {
		super.setUp()

		interactor = ShowProgressService(repository: ShowProgressMocks.showProgressRepository)
		observer = scheduler.createObserver(WatchedShowBuilder.self)
	}

	func testShowProgressService_fetchShowProgress_withoutNextEpisode() {
    let baseShow: BaseShow = TraktEntitiesMock.decodeTraktJSON(with: "trakt_shows_watchedprogress_without_nextepisode")
    let repo = ShowProgressMocks.ShowProgressAPIRepositoryMock(baseShow: baseShow)

    interactor = ShowProgressService(repository: repo)

		let showIds = TraktEntitiesMock.createTraktShowDetails().ids

		_ = interactor.fetchShowProgress(ids: showIds).subscribe(observer)

    let expectedBuilder = WatchedShowBuilder(ids: showIds, detailShow: baseShow, episode: nil)
    let expectedEvents = [next(0, expectedBuilder), completed(0)]

    XCTAssertEqual(observer.events, expectedEvents)
	}

  func testShowProgressService_fetchShowProgress_withNextEpisode() {
    let baseShow: BaseShow = TraktEntitiesMock.decodeTraktJSON(with: "trakt_shows_watchedprogress")
    let repo = ShowProgressMocks.ShowProgressAPIRepositoryMock(baseShow: baseShow, episode: baseShow.nextEpisode)

    interactor = ShowProgressService(repository: repo)

    let showIds = TraktEntitiesMock.createTraktShowDetails().ids

    _ = interactor.fetchShowProgress(ids: showIds).subscribe(observer)

    let expectedBuilder = WatchedShowBuilder(ids: showIds, detailShow: baseShow, episode: baseShow.nextEpisode)
    let expectedEvents = [next(0, expectedBuilder), completed(0)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testShowProgressService_fetchShowProgress_withNextEpisodeReturningError() {
    let baseShow: BaseShow = TraktEntitiesMock.decodeTraktJSON(with: "trakt_shows_watchedprogress")
    let episodeError = NSError(domain: "io.github.pietrocaselani", code: 420, userInfo: nil)
    let repo = ShowProgressMocks.ShowProgressAPIRepositoryMock(baseShow: baseShow, episodeError: episodeError)

    interactor = ShowProgressService(repository: repo)

    let showIds = TraktEntitiesMock.createTraktShowDetails().ids

    _ = interactor.fetchShowProgress(ids: showIds).subscribe(observer)

    let expectedBuilder = WatchedShowBuilder(ids: showIds, detailShow: baseShow)
    let expectedEvents = [next(0, expectedBuilder), completed(0)]

    XCTAssertEqual(observer.events, expectedEvents)
  }
}
