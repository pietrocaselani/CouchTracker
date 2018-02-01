import XCTest
import RxSwift
import RxTest
import TraktSwift

final class ShowProgressAPIRepositoryTest: XCTestCase {
  private var scheduler: TestSchedulers!
  private var observer: TestableObserver<BaseShow>!
  private var episodeObserver: TestableObserver<Episode>!

  override func setUp() {
    super.setUp()
    scheduler = TestSchedulers()
    observer = scheduler.createObserver(BaseShow.self)
    episodeObserver = scheduler.createObserver(Episode.self)
  }

  override func tearDown() {
    scheduler = nil
    super.tearDown()
  }

  func testShowProgressRepository_canInitWithDefaultScheduler() {
    let repository = ShowProgressAPIRepository(trakt: traktProviderMock, schedulers: scheduler)
    XCTAssertNotNil(repository)
  }

  func testShowProgressRepository_cacheIsEmpty_forceUpdate_fetchShowProgressFromAPIAndSaveOnCache() {
    //Given
    let repository = ShowProgressAPIRepository(trakt: traktProviderMock, schedulers: scheduler)

    //When
    _ = repository.fetchShowProgress(showId: "fake show", hidden: false, specials: false, countSpecials: false).subscribe(observer)
    scheduler.start()

    //Then
    let expectedShow = ShowsProgressMocks.createShowMock("fake show")!
    let expectedEvents = [next(1, expectedShow), completed(2)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testShowProgressRepository_fetchDetailsWithEmptyCache_hitsOnAPIAndSavesOnCache() {
    //Given
    let repository = ShowProgressAPIRepository(trakt: traktProviderMock, schedulers: scheduler)

    //When
    _ = repository.fetchDetailsOf(episodeNumber: 1, on: 1, of: "the-americans", extended: .full).subscribe(episodeObserver)
    scheduler.start()

    //Then
    let expectedEpisode = ShowsProgressMocks.createEpisodeMock("the-americans")
    let expectedEvents = [next(1, expectedEpisode), completed(2)]

    XCTAssertEqual(episodeObserver.events, expectedEvents)
  }

  func testShowProgressRepository_fetchDetailsWithCacheNotEmptyForcingUpdate_hitsOnlyOnAPIAndUpdateCache() {
    //Given
    let repository = ShowProgressAPIRepository(trakt: traktProviderMock, schedulers: scheduler)

    //When
    _ = repository.fetchDetailsOf(episodeNumber: 1, on: 1, of: "the-americans", extended: .full).subscribe(episodeObserver)
    scheduler.start()

    //Then
    let expectedShow = ShowsProgressMocks.createEpisodeMock("the-americans")
    let expectedEvents = [next(1, expectedShow), completed(2)]

    XCTAssertEqual(episodeObserver.events, expectedEvents)
  }
}
