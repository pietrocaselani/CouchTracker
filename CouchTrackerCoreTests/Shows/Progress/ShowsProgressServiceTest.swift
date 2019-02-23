@testable import CouchTrackerCore
import RxSwift
import RxTest
import TraktSwift
import XCTest

// CT-TODO Move this to a proper place
private class WatchedShowEntitiesObservableMock: WatchedShowEntitiesObservable {
  private let subject: BehaviorSubject<[WatchedShowEntity]>

  init(shows: [WatchedShowEntity]) {
    subject = BehaviorSubject<[WatchedShowEntity]>(value: shows)
  }

  func observeWatchedShows() -> Observable<[WatchedShowEntity]> {
    return subject
  }

  func emitsAgain(_ shows: [WatchedShowEntity]) {
    subject.onNext(shows)
  }
}

final class ShowsProgressServiceTest: XCTestCase {
  private var scheduler: TestSchedulers!
  private var observer: TestableObserver<[WatchedShowEntity]>!
  private var listStateDataSource: ShowsProgressMocks.ListStateDataSource!
  private var watchedShowEntitiesObservableMock: WatchedShowEntitiesObservableMock!

  override func setUp() {
    super.setUp()

    scheduler = TestSchedulers()

    observer = scheduler.createObserver([WatchedShowEntity].self)

    let watchedShow = ShowsProgressMocks.mockWatchedShowEntity()

    listStateDataSource = ShowsProgressMocks.ListStateDataSource()
    watchedShowEntitiesObservableMock = WatchedShowEntitiesObservableMock(shows: [watchedShow])
  }

  override func tearDown() {
    observer = nil
    scheduler = nil
    listStateDataSource = nil
    watchedShowEntitiesObservableMock = nil

    super.tearDown()
  }

  func testShowsProgressService_fetchWatchedProgress() {
    // Given
    let interactor = ShowsProgressService(listStateDataSource: listStateDataSource,
                                          showsObserable: watchedShowEntitiesObservableMock,
                                          syncStateObservable: SyncStateMocks.SyncStateObservableMock(),
                                          appStateObservable: AppStateMock.AppStateObservableMock(),
                                          schedulers: scheduler)

    // When
//    _ = interactor.fetchWatchedShowsProgress().subscribe(observer)
//    scheduler.start()
    let res = scheduler.start {
      interactor.fetchWatchedShowsProgress()
    }

    // Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [Recorded.next(0, [entity])]

//    RXAssertEvents(observer.events, expectedEvents)
    RXAssertEvents(res.events, expectedEvents)
  }

  func testShowsProgressService_receiveSameDataFromRepository_emitsOnlyOnce() {
    // Given
    let interactor = ShowsProgressService(listStateDataSource: listStateDataSource,
                                          showsObserable: watchedShowEntitiesObservableMock,
                                          syncStateObservable: SyncStateMocks.SyncStateObservableMock(),
                                          appStateObservable: AppStateMock.AppStateObservableMock())
    _ = interactor.fetchWatchedShowsProgress().subscribe(observer)
    scheduler.start()

    // When
    watchedShowEntitiesObservableMock.emitsAgain([ShowsProgressMocks.mockWatchedShowEntity()])

    // Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [Recorded.next(0, [entity])]

    RXAssertEvents(observer.events, expectedEvents)
  }

  func testShowsProgressService_receiveDifferentDataFromRepository_emitsNewData() {
    // Given
    let interactor = ShowsProgressService(listStateDataSource: listStateDataSource,
                                          showsObserable: watchedShowEntitiesObservableMock,
                                          syncStateObservable: SyncStateMocks.SyncStateObservableMock(),
                                          appStateObservable: AppStateMock.AppStateObservableMock())
    _ = interactor.fetchWatchedShowsProgress().subscribe(observer)
    scheduler.start()

    // When
    watchedShowEntitiesObservableMock.emitsAgain([WatchedShowEntity]())

    // Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [Recorded.next(0, [entity]), Recorded.next(0, [WatchedShowEntity]())]

    RXAssertEvents(observer.events, expectedEvents)
  }

  func testShowsProgressService_receivesNewListState_shouldNotifyDataSource() {
    // Given
    let interactor = ShowsProgressService(listStateDataSource: listStateDataSource,
                                          showsObserable: watchedShowEntitiesObservableMock,
                                          syncStateObservable: SyncStateMocks.SyncStateObservableMock(),
                                          appStateObservable: AppStateMock.AppStateObservableMock())

    // When
    let listState = ShowProgressListState(sort: .lastWatched, filter: .watched, direction: .asc)
    interactor.listState = listState

    // Then
    XCTAssertEqual(listStateDataSource.currentStateInvokedCount, 1)
    XCTAssertEqual(listStateDataSource.currentState, listState)
  }
}
