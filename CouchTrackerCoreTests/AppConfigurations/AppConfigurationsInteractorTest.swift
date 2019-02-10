@testable import CouchTrackerCore
import RxSwift
import RxTest
import XCTest

final class AppStateInteractorTest: XCTestCase {
  private let scheduler = TestScheduler(initialClock: 0)
  private var disposeBag: CompositeDisposable!
  private var observer: TestableObserver<AppState>!

  override func setUp() {
    observer = scheduler.createObserver(AppState.self)
    disposeBag = CompositeDisposable()
    super.setUp()
  }

  override func tearDown() {
    disposeBag.dispose()
    super.tearDown()
  }

  func testAppStateInteractor_fetchAppStateFailure_emitsAppInitialState() {
    // Given
    let message = "decrypt error"
    let genericError = NSError(domain: "io.github.pietrocaselani", code: 203, userInfo: [NSLocalizedDescriptionKey: message])
    let appStateDataHolder = AppStateMock.DataHolderMock()
    let appStateManager = AppStateManager(appState: .initialState(),
                                          trakt: createTraktProviderMock(),
                                          dataHolder: appStateDataHolder)
    let interactor = AppStateService(appStateManager: appStateManager)

    // When
    let observable = interactor.fetchAppState()

    // Then
    let disposable = observable.subscribe(observer)
    _ = disposeBag.insert(disposable)

    let expectedEvents: [Recorded<Event<AppState>>] = [Recorded.next(0, AppState.initialState()), Recorded.completed(0)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testAppStateInteractor_fetchUserFailure_emitsInitialState() {
    // Given an empty repository
    let appStateDataHolder = AppStateMock.DataHolderMock()
    let appStateManager = AppStateManager(appState: .initialState(),
                                          trakt: createTraktProviderMock(),
                                          dataHolder: appStateDataHolder)
    let interactor = AppStateService(appStateManager: appStateManager)

    // When
    let observable = interactor.fetchAppState()

    // Then
    let disposable = observable.subscribe(observer)
    _ = disposeBag.insert(disposable)

    let expectedEvents = [Recorded.next(0, AppState.initialState()), Recorded.completed(0)]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testAppStateInteractor_fetchUser_emitsAppStateLogged() {
    // Given a repository with token
    let appStateDataHolder = AppStateMock.DataHolderMock()
    let appStateManager = AppStateManager(appState: .initialState(),
                                          trakt: createTraktProviderMock(),
                                          dataHolder: appStateDataHolder)
    let interactor = AppStateService(appStateManager: appStateManager)

    // When
    let observable = interactor.fetchAppState()

    // Then
    let disposable = observable.subscribe(observer)
    _ = disposeBag.insert(disposable)

    let expectedSettings = TraktEntitiesMock.createUserSettingsMock()
//    let loginState = LoginState.logged(settings: expectedSettings)
    let expectedState = AppState(userSettings: nil, hideSpecials: false)
    let expectedEvents = [Recorded.next(0, expectedState), Recorded.completed(0)]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testAppStateInteractor_toggleHideSpecials_notifyRepository() {
    // Given
    let appStateDataHolder = AppStateMock.DataHolderMock()
    let appStateManager = AppStateManager(appState: .initialState(),
                                          trakt: createTraktProviderMock(),
                                          dataHolder: appStateDataHolder)
    let interactor = AppStateService(appStateManager: appStateManager)

    // When
    _ = interactor.toggleHideSpecials().subscribe()

    // Then
//    XCTAssertTrue(repository.invokedToggleHideSpecials)
  }

  func testAppStateInteractor_fetchLoginStateWithError_emitsNotLogged() {
    // Given
    let message = "decrypt error"
    let genericError = NSError(domain: "io.github.pietrocaselani", code: 203, userInfo: [NSLocalizedDescriptionKey: message])
    let appStateDataHolder = AppStateMock.DataHolderMock()
    let appStateManager = AppStateManager(appState: .initialState(),
                                          trakt: createTraktProviderMock(),
                                          dataHolder: appStateDataHolder)
    let interactor = AppStateService(appStateManager: appStateManager)

    // When
    _ = interactor.fetchAppState().subscribe(observer)

    // Then
    let expectedState = AppState(userSettings: nil, hideSpecials: false)
    let expectedEvents = [Recorded.next(0, expectedState), Recorded.completed(0)]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
