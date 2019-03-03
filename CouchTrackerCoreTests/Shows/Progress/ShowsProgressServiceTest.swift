@testable import CouchTrackerCore
import RxSwift
import RxTest
import TraktSwift
import XCTest

// CT-TODO Move this to a proper place
private class WatchedShowEntitiesObservableMock: WatchedShowEntitiesObservable {
  private let subject: BehaviorSubject<WatchedShowEntitiesState>

  init(shows: [WatchedShowEntity]?) {
    let state = shows.map { WatchedShowEntitiesState.available(shows: $0) } ?? .unavailable
    subject = BehaviorSubject<WatchedShowEntitiesState>(value: state)
  }

  func observeWatchedShows() -> Observable<WatchedShowEntitiesState> {
    return subject
  }

  func emitsAgain(_ shows: [WatchedShowEntity]) {
    subject.onNext(WatchedShowEntitiesState.available(shows: shows))
  }
}

final class ShowsProgressServiceTest: XCTestCase {
  private var scheduler: TestSchedulers!
  private var observer: TestableObserver<WatchedShowEntitiesState>!
  private var listStateDataSource: ShowsProgressMocks.ListStateDataSource!
  private var watchedShowEntitiesObservableMock: WatchedShowEntitiesObservableMock!

  override func setUp() {
    super.setUp()

    scheduler = TestSchedulers()

    observer = scheduler.createObserver(WatchedShowEntitiesState.self)

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
                                          schedulers: scheduler)

    // When
    let res = scheduler.start {
      interactor.fetchWatchedShowsProgress()
    }

    // Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [Recorded.next(200, WatchedShowEntitiesState.available(shows: [entity]))]

    XCTAssertEqual(res.events, expectedEvents)
  }

  func testShowsProgressService_receiveSameDataFromRepository_emitsOnlyOnce() {
    // Given
    let interactor = ShowsProgressService(listStateDataSource: listStateDataSource,
                                          showsObserable: watchedShowEntitiesObservableMock)
    _ = interactor.fetchWatchedShowsProgress().subscribe(observer)
    scheduler.start()

    // When
    watchedShowEntitiesObservableMock.emitsAgain([ShowsProgressMocks.mockWatchedShowEntity()])

    // Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [Recorded.next(0, WatchedShowEntitiesState.available(shows: [entity]))]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testShowsProgressService_receiveDifferentDataFromRepository_emitsNewData() {
    // Given
    let interactor = ShowsProgressService(listStateDataSource: listStateDataSource,
                                          showsObserable: watchedShowEntitiesObservableMock)
    _ = interactor.fetchWatchedShowsProgress().subscribe(observer)
    scheduler.start()

    // When
    watchedShowEntitiesObservableMock.emitsAgain([WatchedShowEntity]())

    // Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [Recorded.next(0, WatchedShowEntitiesState.available(shows: [entity])),
                          Recorded.next(0, WatchedShowEntitiesState.available(shows: [WatchedShowEntity]()))]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testShowsProgressService_receivesNewListState_shouldNotifyDataSource() {
    // Given
    let interactor = ShowsProgressService(listStateDataSource: listStateDataSource,
                                          showsObserable: watchedShowEntitiesObservableMock)

    // When
    let listState = ShowProgressListState(sort: .lastWatched, filter: .watched, direction: .asc)
    interactor.listState = listState

    // Then
    XCTAssertEqual(listStateDataSource.currentStateInvokedCount, 1)
    XCTAssertEqual(listStateDataSource.currentState, listState)
  }
}
