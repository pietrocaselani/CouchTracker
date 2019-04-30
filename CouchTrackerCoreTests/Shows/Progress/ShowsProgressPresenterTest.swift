@testable import CouchTrackerCore
import NonEmpty
import RxSwift
import RxTest
import XCTest

final class ShowsProgressDefaultPresenterTest: XCTestCase {
  private var router: ShowsProgressMocks.ShowsProgressRouterMock!
  private var listStateDataSource: ShowsProgressMocks.ListStateDataSource!
  private var interactor: ShowsProgressInteractor!
  private var presenter: ShowsProgressDefaultPresenter!
  private var schedulers: TestSchedulers!
  private var viewStateObserver: TestableObserver<ShowProgressViewState>!
  private var appStateObservable: AppStateMock.AppStateObservableMock!
  private var syncStateObservable: SyncStateMocks.SyncStateObservableMock!

  override func setUp() {
    super.setUp()

    schedulers = TestSchedulers(initialClock: 0)
    viewStateObserver = schedulers.createObserver(ShowProgressViewState.self)
  }

  private func setupPresenter(logged: Bool = false) {
    router = ShowsProgressMocks.ShowsProgressRouterMock()
    listStateDataSource = ShowsProgressMocks.ListStateDataSource()
    syncStateObservable = SyncStateMocks.SyncStateObservableMock()

    let appState = logged ? AppStateMock.loggedAppState : AppState.initialState()

    appStateObservable = AppStateMock.AppStateObservableMock(appState: appState)

    presenter = ShowsProgressDefaultPresenter(interactor: interactor,
                                              router: router,
                                              appStateObservable: appStateObservable,
                                              syncStateObservable: syncStateObservable)
  }

  override func tearDown() {
    router = nil
    listStateDataSource = nil
    interactor = nil
    presenter = nil
    schedulers = nil
    appStateObservable = nil
    syncStateObservable = nil
    super.tearDown()
  }

  func testShowsProgressPresenter_isLogged_RceivesNothing_emitsEmptyState() {
    // Given
    interactor = ShowsProgressMocks.EmptyShowsProgressInteractorMock()
    setupPresenter(logged: true)

    // When
    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // Then
    let expectedViewState = [Recorded.next(0, ShowProgressViewState.empty)]

    XCTAssertEqual(viewStateObserver.events, expectedViewState)
  }

  func testShowsProgressPresenter_receivesData_emitsShows() {
    // Given
    var entities = [WatchedShowEntity]()
    entities.append(ShowsProgressMocks.mockWatchedShowEntity())
    entities.append(ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode())
    entities.append(ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisodeDate())

    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(entities: entities)
    setupPresenter(logged: true)

    // When
    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // Then
    let nonEmptyEntities = NonEmptyArray(entities.first!, Array(entities.dropFirst()))

    let showViewState = ShowProgressViewState.shows(entities: nonEmptyEntities, menu: ShowsProgressMenuOptions.mock)

    let expectedViewState = [Recorded.next(0, showViewState)]

    XCTAssertEqual(viewStateObserver.events, expectedViewState)
  }

  func testShowsProgressPresenter_notLoggedOnTrakt_notifyView() {
    // Given
    interactor = ShowsProgressMocks.ShowsProgressInteractorMock()
    setupPresenter(logged: false)

    // When
    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // Then
    let expectedViewState = [Recorded.next(0, ShowProgressViewState.notLogged)]

    XCTAssertEqual(viewStateObserver.events, expectedViewState)
  }

  func testShowsProgressPresenter_receivesNotLoggedEvent_updateView() {
    // Given
    interactor = ShowsProgressMocks.ShowsProgressInteractorMock()
    setupPresenter(logged: true)

    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // When
    appStateObservable.change(state: AppState.initialState())

    // Then
    let expectedViewState = [Recorded.next(0, ShowProgressViewState.empty),
                             Recorded.next(0, ShowProgressViewState.notLogged)]

    XCTAssertEqual(viewStateObserver.events, expectedViewState)
  }

  func testShowsProgressDefaultPresenter_selectShow_notifyRouter() {
    // Given
    var entities = [WatchedShowEntity]()
    entities.append(ShowsProgressMocks.mockWatchedShowEntity())
    entities.append(ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode())
    entities.append(ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisodeDate())

    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(entities: entities)
    setupPresenter(logged: true)

    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // When
    presenter.select(show: entities[1])

    // Then
    XCTAssertTrue(router.showTVShowInvoked)
    XCTAssertEqual(router.showTVShowParameter, entities[1])
  }

  func testShowsProgressDefaultPresenter_receivesErrorFromInteractor_notifyViewAndDataSource() {
    // Given
    let message = "Realm file is corrupted"
    let userInfo = [NSLocalizedDescriptionKey: message]
    let error = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 35, userInfo: userInfo)

    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(error: error)
    setupPresenter(logged: true)

    // When
    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // Then
    let expectedViewState = [Recorded.next(0, ShowProgressViewState.error(error: error)),
                             Recorded.completed(0)]

    XCTAssertEqual(viewStateObserver.events, expectedViewState)
  }

  func testShowsProgressPresenter_whenChangeSortAndFilter_shouldNotifyInteractor() {
    // Given
    var entities = [WatchedShowEntity]()
    entities.append(ShowsProgressMocks.mockWatchedShowEntity())
    entities.append(ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode())
    entities.append(ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisodeDate())

    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(entities: entities)
    setupPresenter(logged: true)

    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // When
    _ = presenter.change(sort: .releaseDate, filter: .watched).subscribe()

    // Then
    XCTAssertEqual((interactor as! ShowsProgressMocks.ShowsProgressInteractorMock).changeInvokedCount, 1)
  }

  func testShowsProgressPresenter_whenChangeDirection_shouldNotifyInteractor() {
    // Given
    var entities = [WatchedShowEntity]()
    entities.append(ShowsProgressMocks.mockWatchedShowEntity())
    entities.append(ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode())
    entities.append(ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisodeDate())

    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(entities: entities)
    setupPresenter(logged: true)

    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // When
    _ = presenter.toggleDirection().subscribe()

    // Then
    XCTAssertEqual((interactor as! ShowsProgressMocks.ShowsProgressInteractorMock).toggleDirectionInvokedCount, 1)
  }

  func testShowsProgressPresenter_whenDirectionIsDesc_emitsShowsReversed() {
    // Given
    var entities = [WatchedShowEntity]()
    entities.append(ShowsProgressMocks.mockWatchedShowEntity())
    entities.append(ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode())
    entities.append(ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisodeDate())

    let initialListState = ShowProgressListState(sort: .title, filter: .none, direction: .desc)

    interactor = ShowsProgressMocks.ShowsProgressInteractorMock(entities: entities,
                                                                error: nil,
                                                                listState: initialListState)
    setupPresenter(logged: true)

    // When
    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // Then
    let reversedList = entities.reversed()
    let nonEmptyEntities = NonEmptyArray(reversedList.first!, Array(reversedList.dropFirst()))

    let showViewState = ShowProgressViewState.shows(entities: nonEmptyEntities, menu: ShowsProgressMenuOptions.mock)

    let expectedViewState = [Recorded.next(0, showViewState)]

    XCTAssertEqual(viewStateObserver.events, expectedViewState)
  }
}
