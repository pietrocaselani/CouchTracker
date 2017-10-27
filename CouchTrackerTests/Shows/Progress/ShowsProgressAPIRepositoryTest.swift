import XCTest
import RxSwift
import RxTest
import Trakt

final class ShowsProgressAPIRepositoryTest: XCTestCase {
  private let cache = CacheMock()
  private let trakt = TraktProviderMock()
  private let scheduler = TestScheduler(initialClock: 0)
  private let disposeBag = CompositeDisposable()

  override func tearDown() {
    cache.entries.removeAll()
    disposeBag.dispose()
    super.tearDown()
  }

  func testShowsProgressRepository_fetchesShowsWithEmptyCache_hitOnAPISavesOnCache() {
    //Given
    let repository = ShowsProgressAPIRepository(trakt: trakt, cache: AnyCache(cache), scheduler: scheduler)
    let observer = scheduler.createObserver([BaseShow].self)

    //When
    _ = repository.fetchWatchedShows(update: false, extended: .full).subscribe(observer)
    scheduler.start()

    //Then
    let expectedShows = ShowsProgressMocks.createWatchedShowsMock()
    let expectedEvents = [next(0, expectedShows), completed(0)]

    RXAssertEvents(observer, expectedEvents)
    XCTAssertFalse(cache.entries.isEmpty)
    XCTAssertTrue(cache.getInvoked)
    XCTAssertTrue(cache.setInvoked)
  }

  func testShowsProgressRepository_fetchesShowsForcingUpdate_cantHitOnCache() {
    //Given
    let repository = ShowsProgressAPIRepository(trakt: trakt, cache: AnyCache(cache), scheduler: scheduler)
    let observer = scheduler.createObserver([BaseShow].self)

    //When
    _ = repository.fetchWatchedShows(update: true, extended: .full).subscribe(observer)
    scheduler.start()

    //Then
    let expectedShows = ShowsProgressMocks.createWatchedShowsMock()
    let expectedEvents = [next(0, expectedShows), completed(0)]

    RXAssertEvents(observer, expectedEvents)
    XCTAssertFalse(cache.entries.isEmpty)
    XCTAssertFalse(cache.getInvoked)
    XCTAssertTrue(cache.setInvoked)
  }

  func testShowsProgressRepository_fetchesShowsFromCache_cantHitOnAPI() {
    //Given
    let target = Sync.watched(type: .shows, extended: .full)
    let entriesCache = CacheMock(entries: [target.hashValue: target.sampleData as NSData])
    let repository = ShowsProgressAPIRepository(trakt: trakt, cache: AnyCache(entriesCache), scheduler: scheduler)
    let observer = scheduler.createObserver([BaseShow].self)

    //When
    _ = repository.fetchWatchedShows(update: false, extended: .full).subscribe(observer)
    scheduler.start()

    //Then
    let expectedShows = ShowsProgressMocks.createWatchedShowsMock()
    let expectedEvents = [next(0, expectedShows), completed(0)]

    RXAssertEvents(observer, expectedEvents)
    XCTAssertTrue(entriesCache.getInvoked)
    XCTAssertFalse(entriesCache.setInvoked)
  }
}
