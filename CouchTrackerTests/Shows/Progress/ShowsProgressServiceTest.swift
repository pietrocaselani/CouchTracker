import XCTest
import RxSwift
import RxTest
import TraktSwift

final class ShowsProgressServiceTest: XCTestCase {
  private let scheduler = TestSchedulers()
  private var observer: TestableObserver<[WatchedShowEntity]>!
  private var repository: ShowsProgressRepository!

  override func setUp() {
    super.setUp()

    observer = scheduler.createObserver([WatchedShowEntity].self)

    repository = ShowsProgressMocks.ShowsProgressRepositoryMock(trakt: traktProviderMock)
  }

  func testShowsProgressService_fetchWatchedProgress() {
    //Given
    let interactor = ShowsProgressService(repository: repository, schedulers: scheduler)

    //When
    _ = interactor.fetchWatchedShowsProgress().subscribe(observer)
    scheduler.start()

    //Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [next(0, [entity]), completed(0)]

    RXAssertEvents(observer.events, expectedEvents)
  }
}
