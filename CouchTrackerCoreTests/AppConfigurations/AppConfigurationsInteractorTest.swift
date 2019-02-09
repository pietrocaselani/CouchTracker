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
    let repository = AppStateRepositoryErrorMock(error: genericError)
    let output = AppStateMock.AppStateOutputMock()
    let interactor = AppStateService(repository: repository, output: output)

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
    let repository = AppStateRepositoryMock(usersProvider: createTraktProviderMock().users, isEmpty: true)
    let output = AppStateMock.AppStateOutputMock()
    let interactor = AppStateService(repository: repository, output: output)

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
    let repository = AppStateRepositoryMock(usersProvider: createTraktProviderMock().users)
    let output = AppStateMock.AppStateOutputMock()
    let interactor = AppStateService(repository: repository, output: output)

    // When
    let observable = interactor.fetchAppState()

    // Then
    let disposable = observable.subscribe(observer)
    _ = disposeBag.insert(disposable)

    let expectedSettings = TraktEntitiesMock.createUserSettingsMock()
    let loginState = LoginState.logged(settings: expectedSettings)
    let expectedState = AppState(loginState: loginState, hideSpecials: false)
    let expectedEvents = [Recorded.next(0, expectedState), Recorded.completed(0)]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testAppStateInteractor_toggleHideSpecials_notifyRepository() {
    // Given
    let repository = AppStateRepositoryMock(usersProvider: createTraktProviderMock().users)
    let output = AppStateMock.AppStateOutputMock()
    let interactor = AppStateService(repository: repository, output: output)

    // When
    _ = interactor.toggleHideSpecials().subscribe()

    // Then
    XCTAssertTrue(repository.invokedToggleHideSpecials)
  }

  func testAppStateInteractor_fetchLoginStateWithError_emitsNotLogged() {
    // Given
    let message = "decrypt error"
    let genericError = NSError(domain: "io.github.pietrocaselani", code: 203, userInfo: [NSLocalizedDescriptionKey: message])
    let repository = AppStateRepositoryErrorMock(loginError: genericError)
    let output = AppStateMock.AppStateOutputMock()
    let interactor = AppStateService(repository: repository, output: output)

    // When
    _ = interactor.fetchAppState().subscribe(observer)

    // Then
    let expectedState = AppState(loginState: .notLogged, hideSpecials: false)
    let expectedEvents = [Recorded.next(0, expectedState), Recorded.completed(0)]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
