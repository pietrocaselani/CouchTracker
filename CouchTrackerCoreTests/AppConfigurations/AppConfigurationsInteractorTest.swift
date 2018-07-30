@testable import CouchTrackerCore
import RxSwift
import RxTest
import XCTest

final class AppConfigurationsInteractorTest: XCTestCase {
    private let scheduler = TestScheduler(initialClock: 0)
    private var disposeBag: CompositeDisposable!
    private var observer: TestableObserver<AppConfigurationsState>!

    override func setUp() {
        observer = scheduler.createObserver(AppConfigurationsState.self)
        disposeBag = CompositeDisposable()
        super.setUp()
    }

    override func tearDown() {
        disposeBag.dispose()
        super.tearDown()
    }

    func testAppConfigurationsInteractor_fetchAppStateFailure_emitsAppInitialState() {
        // Given
        let message = "decrypt error"
        let genericError = NSError(domain: "io.github.pietrocaselani", code: 203, userInfo: [NSLocalizedDescriptionKey: message])
        let repository = AppConfigurationsRepositoryErrorMock(error: genericError)
        let output = AppConfigurationsMock.AppConfigurationsOutputMock()
        let interactor = AppConfigurationsService(repository: repository, output: output)

        // When
        let observable = interactor.fetchAppConfigurationsState()

        // Then
        let disposable = observable.subscribe(observer)
        _ = disposeBag.insert(disposable)

        let expectedEvents: [Recorded<Event<AppConfigurationsState>>] = [next(0, AppConfigurationsState.initialState()), completed(0)]

        XCTAssertEqual(observer.events, expectedEvents)
    }

    func testAppConfigurationsInteractor_fetchUserFailure_emitsInitialState() {
        // Given an empty repository
        let repository = AppConfigurationsRepositoryMock(usersProvider: createTraktProviderMock().users, isEmpty: true)
        let output = AppConfigurationsMock.AppConfigurationsOutputMock()
        let interactor = AppConfigurationsService(repository: repository, output: output)

        // When
        let observable = interactor.fetchAppConfigurationsState()

        // Then
        let disposable = observable.subscribe(observer)
        _ = disposeBag.insert(disposable)

        let expectedEvents = [next(0, AppConfigurationsState.initialState()), completed(0)]
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func testAppConfigurationsInteractor_fetchUser_emitsAppStateLogged() {
        // Given a repository with token
        let repository = AppConfigurationsRepositoryMock(usersProvider: createTraktProviderMock().users)
        let output = AppConfigurationsMock.AppConfigurationsOutputMock()
        let interactor = AppConfigurationsService(repository: repository, output: output)

        // When
        let observable = interactor.fetchAppConfigurationsState()

        // Then
        let disposable = observable.subscribe(observer)
        _ = disposeBag.insert(disposable)

        let expectedSettings = TraktEntitiesMock.createUserSettingsMock()
        let loginState = LoginState.logged(settings: expectedSettings)
        let expectedState = AppConfigurationsState(loginState: loginState, hideSpecials: false)
        let expectedEvents = [next(0, expectedState), completed(0)]
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func testAppConfigurationsInteractor_toggleHideSpecials_notifyRepository() {
        // Given
        let repository = AppConfigurationsRepositoryMock(usersProvider: createTraktProviderMock().users)
        let output = AppConfigurationsMock.AppConfigurationsOutputMock()
        let interactor = AppConfigurationsService(repository: repository, output: output)

        // When
        _ = interactor.toggleHideSpecials().subscribe()

        // Then
        XCTAssertTrue(repository.invokedToggleHideSpecials)
    }

    func testAppConfigurationsInteractor_fetchLoginStateWithError_emitsNotLogged() {
        // Given
        let message = "decrypt error"
        let genericError = NSError(domain: "io.github.pietrocaselani", code: 203, userInfo: [NSLocalizedDescriptionKey: message])
        let repository = AppConfigurationsRepositoryErrorMock(loginError: genericError)
        let output = AppConfigurationsMock.AppConfigurationsOutputMock()
        let interactor = AppConfigurationsService(repository: repository, output: output)

        // When
        _ = interactor.fetchAppConfigurationsState().subscribe(observer)

        // Then
        let expectedState = AppConfigurationsState(loginState: .notLogged, hideSpecials: false)
        let expectedEvents = [next(0, expectedState), completed(0)]
        XCTAssertEqual(observer.events, expectedEvents)
    }
}
