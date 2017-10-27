import XCTest
import RxSwift
import RxTest
import Trakt

final class ShowProgressAPIRepositoryTest: XCTestCase {
  private var scheduler: TestScheduler!
  private var cache: CacheMock!
  private var observer: TestableObserver<BaseShow>!
  private var episodeObserver: TestableObserver<Episode>!

  override func setUp() {
    super.setUp()
    scheduler = TestScheduler(initialClock: 0)
    cache = CacheMock()
    observer = scheduler.createObserver(BaseShow.self)
    episodeObserver = scheduler.createObserver(Episode.self)
  }

  override func tearDown() {
    scheduler = nil
    cache = nil
    super.tearDown()
  }

  func testShowProgressRepository_canInitWithDefaultScheduler() {
    let repository = ShowProgressAPIRepository(trakt: traktProviderMock, cache: AnyCache(cache))
    XCTAssertNotNil(repository)
  }

  func testShowProgressRepository_cacheIsEmpty_forceUpdate_fetchShowProgressFromAPIAndSaveOnCache() {
    //Given
    let repository = ShowProgressAPIRepository(trakt: traktProviderMock, cache: AnyCache(cache), scheduler: scheduler)

    //When
    _ = repository.fetchShowProgress(update: true, showId: "fake show", hidden: false, specials: false, countSpecials: false).subscribe(observer)
    scheduler.start()

    //Then
    let expectedShow = ShowsProgressMocks.createShowMock("fake show")!
    let expectedEvents = [next(1, expectedShow), completed(2)]

    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertFalse(cache.getInvoked)
    XCTAssertTrue(cache.setInvoked)
  }

  func testShowProgressRepository_cacheNotEmpty_dontForceUpdate_fetchShowProgressFromCacheOnly() {
    //Given
    let target = Shows.watchedProgress(showId: "fake show", hidden: false, specials: false, countSpecials: false)
    cache = CacheMock(entries: [target.hashValue: target.sampleData as NSData])
    let repository = ShowProgressAPIRepository(trakt: traktProviderMock, cache: AnyCache(cache), scheduler: scheduler)

    //When
    _ = repository.fetchShowProgress(update: false, showId: "fake show", hidden: false, specials: false, countSpecials: false).subscribe(observer)
    scheduler.start()

    //Then
    let expectedShow = ShowsProgressMocks.createShowMock("fake show")!
    let expectedEvents = [next(2, expectedShow), completed(3)]

    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertTrue(cache.getInvoked)
    XCTAssertFalse(cache.setInvoked)
  }

  func testShowProgressRepository_cacheWithError_fetchesFromAPI() {
    //Given
    let target = Shows.watchedProgress(showId: "fake show", hidden: false, specials: false, countSpecials: false)
    cache = CacheErrorMock(entries: [target.hashValue: target.sampleData as NSData],
                           error: NSError(domain: "com.arctouch", code: 501, userInfo: nil))
    let repository = ShowProgressAPIRepository(trakt: traktProviderMock, cache: AnyCache(cache), scheduler: scheduler)

    //When
    _ = repository.fetchShowProgress(update: false, showId: "fake show", hidden: false, specials: false, countSpecials: false).subscribe(observer)
    scheduler.start()

    //Then
    let expectedShow = ShowsProgressMocks.createShowMock("fake show")!
    let expectedEvents = [next(3, expectedShow), completed(4)]

    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertTrue(cache.getInvoked)
    XCTAssertTrue(cache.setInvoked)
  }

  func testShowProgressRepository_fetchDetailsWithEmptyCache_hitsOnAPIAndSavesOnCache() {
    //Given
    let repository = ShowProgressAPIRepository(trakt: traktProviderMock, cache: AnyCache(cache), scheduler: scheduler)

    //When
    _ = repository.fetchDetailsOf(update: false, episodeNumber: 1, on: 1, of: "the-americans", extended: .full).subscribe(episodeObserver)
    scheduler.start()

    //Then
    let expectedEpisode = ShowsProgressMocks.createEpisodeMock("the-americans")
    let expectedEvents = [next(3, expectedEpisode), completed(4)]

    XCTAssertEqual(episodeObserver.events, expectedEvents)
    XCTAssertTrue(cache.getInvoked)
    XCTAssertTrue(cache.setInvoked)
    XCTAssertFalse(cache.entries.isEmpty)
  }

  func testShowProgressRepository_fetchDetailsWithCacheNotEmptyForcingUpdate_hitsOnlyOnAPIAndUpdateCache() {
    //Given
    let target = Episodes.summary(showId: "the-americans", season: 1, episode: 1, extended: .full)
    cache = CacheMock(entries: [target.hashValue: target.sampleData as NSData])
    let repository = ShowProgressAPIRepository(trakt: traktProviderMock, cache: AnyCache(cache), scheduler: scheduler)

    //When
    _ = repository.fetchDetailsOf(update: true, episodeNumber: 1, on: 1, of: "the-americans", extended: .full).subscribe(episodeObserver)
    scheduler.start()

    //Then
    let expectedShow = ShowsProgressMocks.createEpisodeMock("the-americans")
    let expectedEvents = [next(1, expectedShow), completed(2)]

    XCTAssertEqual(episodeObserver.events, expectedEvents)
    XCTAssertFalse(cache.getInvoked)
    XCTAssertTrue(cache.setInvoked)
  }
}
