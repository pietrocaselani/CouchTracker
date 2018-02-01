import XCTest
import RxSwift
import RxTest
import TraktSwift

final class ShowsProgressAPIRepositoryTest: XCTestCase {
  private let trakt = TraktProviderMock()
  private let schedulers = TestSchedulers()
  private let disposeBag = CompositeDisposable()

  override func tearDown() {
    disposeBag.dispose()
    super.tearDown()
  }

  func testShowsProgressRepository_fetchesShowsWithEmptyCache_hitOnAPISavesOnCache() {
    //Given
    let repository = ShowsProgressAPIRepository(trakt: trakt, schedulers: schedulers)
    let observer = schedulers.createObserver([BaseShow].self)

    //When
    _ = repository.fetchWatchedShows(update: false, extended: .full).subscribe(observer)
    schedulers.start()

    //Then
    let expectedShows = ShowsProgressMocks.createWatchedShowsMock()
    let expectedEvents = [next(0, expectedShows), completed(0)]

    RXAssertEvents(observer, expectedEvents)
//    XCTAssertFalse(cache.entries.isEmpty)
//    XCTAssertTrue(cache.getInvoked)
//    XCTAssertTrue(cache.setInvoked)
  }

  func testShowsProgressRepository_fetchesShowsForcingUpdate_cantHitOnCache() {
    //Given
    let repository = ShowsProgressAPIRepository(trakt: trakt, schedulers: schedulers)
    let observer = schedulers.createObserver([BaseShow].self)

    //When
    _ = repository.fetchWatchedShows(update: true, extended: .full).subscribe(observer)
    schedulers.start()

    //Then
    let expectedShows = ShowsProgressMocks.createWatchedShowsMock()
    let expectedEvents = [next(0, expectedShows), completed(0)]

    RXAssertEvents(observer, expectedEvents)
//    XCTAssertFalse(cache.entries.isEmpty)
//    XCTAssertFalse(cache.getInvoked)
//    XCTAssertTrue(cache.setInvoked)
  }

  func testShowsProgressRepository_fetchesShowsFromCache_cantHitOnAPI() {
    //Given
//    let target = Sync.watched(type: .shows, extended: .full)
//    let entriesCache = CacheMock(entries: [target.hashValue: target.sampleData as NSData])
    let repository = ShowsProgressAPIRepository(trakt: trakt, schedulers: schedulers)
    let observer = schedulers.createObserver([BaseShow].self)

    //When
    _ = repository.fetchWatchedShows(update: false, extended: .full).subscribe(observer)
    schedulers.start()

    //Then
    let expectedShows = ShowsProgressMocks.createWatchedShowsMock()
    let expectedEvents = [next(0, expectedShows), completed(0)]

    RXAssertEvents(observer, expectedEvents)
//    XCTAssertTrue(entriesCache.getInvoked)
//    XCTAssertFalse(entriesCache.setInvoked)
  }
}
