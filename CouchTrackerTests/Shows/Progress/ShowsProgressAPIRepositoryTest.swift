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
    let observer = schedulers.createObserver([WatchedShowEntity].self)

    //When
    _ = repository.fetchWatchedShows(extended: .full).subscribe(observer)
    schedulers.start()

    //Then
    let expectedShow = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [next(0, [WatchedShowEntity]()), next(6, [expectedShow])]

    RXAssertEvents(observer.events, expectedEvents)
	  XCTAssertTrue(dataSource.fetchWatchedShowsInvoked)
	  XCTAssertTrue(dataSource.addWatchedShowInvoked)
    XCTAssertEqual([expectedShow], dataSource.addedEntities)
  }
}
