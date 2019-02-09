@testable import CouchTrackerCore
import RxTest
import TraktSwift
import XCTest

final class AppStatePresenterTest: XCTestCase {
  private var router: AppStateRouterMock!
  private var presenter: AppStateDefaultPresenter!
  private var interactor: AppStateInteractorMock!
  private var interactorError: AppStateInteractorErrorMock!
  private var scheduler: TestScheduler!
  private var viewStateObserver: TestableObserver<AppStateViewState>!

  override func tearDown() {
    super.tearDown()
    presenter = nil
    router = nil
    interactor = nil
    scheduler = nil
    viewStateObserver = nil
  }

  override func setUp() {
    super.setUp()
    router = AppStateRouterMock()
    scheduler = TestScheduler(initialClock: 0)
    viewStateObserver = scheduler.createObserver(AppStateViewState.self)
  }

  private func setUpModuleWithError(_ error: Error) {
    let repository = AppStateRepositoryErrorMock(error: error)
    let output = AppStateMock.AppStateOutputMock()
    let interactor = AppStateInteractorMock(repository: repository, output: output)
    presenter = AppStateDefaultPresenter(interactor: interactor, router: router)
  }

  private func setupModule(error: Error) {
    router = AppStateRouterMock()
    let repository = AppStateRepositoryMock(usersProvider: createTraktProviderMock().users, isEmpty: true)
    let output = AppStateMock.AppStateOutputMock()
    let interactor = AppStateInteractorErrorMock(repository: repository, output: output)
    interactor.error = error
    presenter = AppStateDefaultPresenter(interactor: interactor, router: router)
  }

  private func setupModule(empty: Bool = false) {
    router = AppStateRouterMock()
    let repository = AppStateRepositoryMock(usersProvider: createTraktProviderMock().users, isEmpty: empty)
    let output = AppStateMock.AppStateOutputMock()
    interactor = AppStateInteractorMock(repository: repository, output: output)
    presenter = AppStateDefaultPresenter(interactor: interactor, router: router)
  }

  func testAppStatePresenter_receivesGenericError_notifyViewNotLogged() {
    // Given
    let message = "decrypt error"
    setUpModuleWithError(NSError(domain: "io.github.pietrocaselani", code: 203, userInfo: [NSLocalizedDescriptionKey: message]))

    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // When
    presenter.viewDidLoad()

    // Then
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connect to Trakt", subtitle: nil, value: .traktLogin(wantsToLogin: true))
    let traktViewModel = AppStateViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: false))
    let generalViewModel = AppStateViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let goToGithubViewModel = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel = AppStateViewModel(title: "Other", configurations: [goToGithubViewModel])

    let viewModels = [traktViewModel, generalViewModel, otherViewModel]

    let expectedEvents = [Recorded.next(0, AppStateViewState.loading),
                          Recorded.next(0, AppStateViewState.showing(configs: viewModels))]

    XCTAssertEqual(viewStateObserver.events, expectedEvents)
  }

  func testAppStatePresenter_receivesUserNotLoggedError_notifyView() {
    // Given
    setUpModuleWithError(AppStateMock.createUnauthorizedErrorMock())

    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // When
    presenter.viewDidLoad()

    // Then
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connect to Trakt", subtitle: nil, value: .traktLogin(wantsToLogin: true))
    let traktViewModel = AppStateViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: false))
    let generalViewModel = AppStateViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let goToGithubViewModel = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel = AppStateViewModel(title: "Other", configurations: [goToGithubViewModel])

    let viewModels = [traktViewModel, generalViewModel, otherViewModel]

    let expectedEvents = [Recorded.next(0, AppStateViewState.loading),
                          Recorded.next(0, AppStateViewState.showing(configs: viewModels))]

    XCTAssertEqual(viewStateObserver.events, expectedEvents)
  }

  func testAppStatePresenter_receivesUserLogged_notifyView() {
    // Given
    setupModule()

    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // When
    presenter.viewDidLoad()

    // Then
    let expectedUserName = AppStateMock.createUserMock().name
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connected", subtitle: expectedUserName, value: .none)
    let traktViewModel = AppStateViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: false))
    let generalViewModel = AppStateViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let goToGithubViewModel = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel = AppStateViewModel(title: "Other", configurations: [goToGithubViewModel])

    let viewModels = [traktViewModel, generalViewModel, otherViewModel]

    let expectedEvents = [Recorded.next(0, AppStateViewState.loading),
                          Recorded.next(0, AppStateViewState.showing(configs: viewModels))]

    XCTAssertEqual(viewStateObserver.events, expectedEvents)
  }

  func testAppStatePresenter_receivesEventAlreadyConnectedToTraktFromView_doesNothing() {
    // Given
    setupModule()

    // When
    presenter.viewDidLoad()

    let connectToTrakt = AppConfigurationViewModel(title: "", subtitle: "", value: .none)
    presenter.select(configuration: connectToTrakt)

    // Then
    XCTAssertFalse(router.invokedShowTraktLogin)
  }

  func testAppStatePresenter_receivesEventConnectToTraktFromView_notifyRouter() {
    // Given
    setupModule(empty: true)
    presenter.viewDidLoad()

    // When
    let connectToTrakt = AppConfigurationViewModel(title: "", subtitle: "", value: .traktLogin(wantsToLogin: true))
    presenter.select(configuration: connectToTrakt)

    // Then
    XCTAssertTrue(router.invokedShowTraktLogin)
  }

  func testAppStatePresenter_receivesEventGoToGithubFromView_notifyRouter() {
    // Given
    setupModule(empty: true)
    presenter.viewDidLoad()

    // When
    let url = URL(validURL: "https://github.com")
    let connectToTrakt = AppConfigurationViewModel(title: "", subtitle: "", value: .externalURL(url: url))
    presenter.select(configuration: connectToTrakt)

    // Then
    XCTAssertEqual(router.showExternalURLInvokedCount, 1)
    XCTAssertEqual(router.showExternalURLLastParameter, url)
  }

  func testAppStatePresenter_receivesEventToggleHideSpecials_notifyInteractor() {
    // Given
    setupModule(empty: true)
    presenter.viewDidLoad()

    // When
    let connectToTrakt = AppConfigurationViewModel(title: "", subtitle: "", value: .hideSpecials(wantsToHideSpecials: false))
    presenter.select(configuration: connectToTrakt)

    // Then
    XCTAssertTrue(interactor.toggleHideSpecialsInvoked)
  }

  func testAppStatePresenter_receivesErrorFromInteractor_notifyRouter() {
    // Given
    let error = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 2002, userInfo: nil)
    setupModule(error: error)

    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // When
    presenter.viewDidLoad()

    // Then
    XCTAssertTrue(router.invokedShowErrorMessage)
  }

  func testAppConfigrationsPresenter_receivesTraktLoginError_notifyRouter() {
    // Given
    setupModule(empty: true)

    // When
    let message = "User or password invalid"
    presenter.logInFail(message: message)

    // Then
    XCTAssertTrue(router.invokedShowErrorMessage)

    guard let receivedMessage = router.invokedShowErrorMessageParameters?.message else {
      XCTFail("Parameter can't be nil")
      return
    }

    XCTAssertEqual(receivedMessage, message)
  }

  func testAppConfigrationsPresenter_receivesTraktLogin_updatesView() {
    // Given
    setupModule(empty: false)
    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // When
    presenter.loggedInSuccessfully()

    // Then
    let expectedUserName = AppStateMock.createUserMock().name
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connected", subtitle: expectedUserName, value: .none)
    let traktViewModel = AppStateViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: false))
    let generalViewModel = AppStateViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let goToGithubViewModel = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel = AppStateViewModel(title: "Other", configurations: [goToGithubViewModel])

    let viewModels = [traktViewModel, generalViewModel, otherViewModel]

    let expectedEvents = [Recorded.next(0, AppStateViewState.loading),
                          Recorded.next(0, AppStateViewState.showing(configs: viewModels))]

    XCTAssertEqual(viewStateObserver.events, expectedEvents)
  }
}
