import XCTest
import RxSwift
import RxTest
import Trakt

final class ShowsProgressServiceTest: XCTestCase {
  private let repository = ShowsProgressMocks.ShowsProgressRepositoryMock(trakt: traktProviderMock, cache: AnyCache(CacheMock()))
  private let showProgressInteractor = ShowProgressMocks.ShowProgressServiceMock(repository: ShowProgressMocks.showProgressRepository)
  private let scheduler = TestScheduler(initialClock: 0)
  private var observer: TestableObserver<WatchedShowEntity>!

  override func setUp() {
    super.setUp()

    observer = scheduler.createObserver(WatchedShowEntity.self)
  }

  func testShowsProgressService_fetchWatchedProgress() {
    //Given
    let interactor = ShowsProgressService(repository: repository, showProgressInteractor: showProgressInteractor)

    //When
    _ = interactor.fetchWatchedShowsProgress(update: false).subscribe(observer)

    //Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [next(0, entity), completed(0)]

    XCTAssertEqual(observer.events, expectedEvents)
  }
}
