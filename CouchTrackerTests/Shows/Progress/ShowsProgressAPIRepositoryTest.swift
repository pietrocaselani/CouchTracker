import XCTest
import RxSwift
import RxTest
import TraktSwift

final class ShowsProgressAPIRepositoryTest: XCTestCase {
  private let trakt = TraktProviderMock()
  private let schedulers = TestSchedulers()

  override func tearDown() {
    super.tearDown()
  }

  func testShowsProgressRepository_fetchesShowsWithEmptyCache_hitOnAPISavesOnCache() {
    //Given
    let dataSource = ShowsProgressMocks.ShowsProgressDataSourceMock()
    let repository = ShowsProgressAPIRepository(trakt: trakt, dataSource: dataSource, schedulers: schedulers)
    let observer = schedulers.createObserver(WatchedShowEntity.self)

    //When
    _ = repository.fetchWatchedShows(update: false, extended: .full).subscribe(observer)
    schedulers.start()

    //Then
    let expectedShow = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [next(6, expectedShow), completed(7)]

    XCTAssertEqual(observer.events, expectedEvents)
	  XCTAssertTrue(dataSource.fetchWatchedShowsInvoked)
	  XCTAssertTrue(dataSource.addWatchedShowInvoked)
    XCTAssertEqual([expectedShow], dataSource.addedEntities)
  }

  func testShowsProgressRepository_fetchesShowsForcingUpdate_cantHitOnCache() {
    //Given
    let dataSource = ShowsProgressMocks.ShowsProgressDataSourceMock()
    let repository = ShowsProgressAPIRepository(trakt: trakt, dataSource: dataSource, schedulers: schedulers)
    let observer = schedulers.createObserver(WatchedShowEntity.self)

    //When
    _ = repository.fetchWatchedShows(update: true, extended: .full).subscribe(observer)
    schedulers.start()

    //Then
    let expectedShow = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [next(5, expectedShow), completed(6)]

    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertFalse(dataSource.fetchWatchedShowsInvoked)
    XCTAssertTrue(dataSource.addWatchedShowInvoked)
    XCTAssertEqual([expectedShow], dataSource.addedEntities)
  }

  func testShowsProgressRepository_fetchesShowsFromCache_cantHitOnAPI() {
    //Given
    let expectedShow = ShowsProgressMocks.mockWatchedShowEntity()
    let dataSource = ShowsProgressMocks.ShowsProgressDataSourceMock(entities: [expectedShow])
    let repository = ShowsProgressAPIRepository(trakt: trakt, dataSource: dataSource, schedulers: schedulers)
    let observer = schedulers.createObserver(WatchedShowEntity.self)

    //When
    _ = repository.fetchWatchedShows(update: false, extended: .full).subscribe(observer)
    schedulers.start()

    //Then

    let expectedEvents = [next(1, expectedShow), completed(1)]

    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertTrue(dataSource.fetchWatchedShowsInvoked)
    XCTAssertFalse((trakt.sync as! MoyaProviderMock).requestInvoked)
    XCTAssertFalse(dataSource.addWatchedShowInvoked)
  }
}
