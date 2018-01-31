import XCTest
import RxSwift
import RxTest
import TraktSwift

final class ShowsProgressServiceTest: XCTestCase {
  private let showProgressInteractor = ShowProgressMocks.ShowProgressServiceMock(repository: ShowProgressMocks.showProgressRepository)
  private let scheduler = TestSchedulers()
  private var observer: TestableObserver<WatchedShowEntity>!
  private var repository: ShowsProgressRepository!

  override func setUp() {
    super.setUp()

    observer = scheduler.createObserver(WatchedShowEntity.self)

    let cache = AnyCache(CacheMock())
    repository = ShowsProgressMocks.ShowsProgressRepositoryMock(trakt: traktProviderMock, cache: cache)
  }

  func testShowsProgressService_fetchWatchedProgress() {
    //Given
    let interactor = ShowsProgressService(repository: repository, showProgressInteractor: showProgressInteractor, schedulers: scheduler)

    //When
    _ = interactor.fetchWatchedShowsProgress(update: false).subscribe(observer)
    scheduler.start()

    //Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [next(2, entity), completed(3)]

    XCTAssertEqual(observer.events, expectedEvents)
  }
}
