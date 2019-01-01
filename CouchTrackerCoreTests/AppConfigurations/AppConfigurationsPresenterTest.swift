@testable import CouchTrackerCore
import RxTest
import TraktSwift
import XCTest

final class AppConfigurationsPresenterTest: XCTestCase {
  private var router: AppConfigurationsRouterMock!
  private var presenter: AppConfigurationsDefaultPresenter!
  private var interactor: AppConfigurationsInteractorMock!
  private var interactorError: AppConfigurationsInteractorErrorMock!
  private var scheduler: TestScheduler!
  private var viewStateObserver: TestableObserver<AppConfigurationsViewState>!

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
    router = AppConfigurationsRouterMock()
    scheduler = TestScheduler(initialClock: 0)
    viewStateObserver = scheduler.createObserver(AppConfigurationsViewState.self)
  }

  private func setUpModuleWithError(_ error: Error) {
    let repository = AppConfigurationsRepositoryErrorMock(error: error)
    let output = AppConfigurationsMock.AppConfigurationsOutputMock()
    let interactor = AppConfigurationsInteractorMock(repository: repository, output: output)
    presenter = AppConfigurationsDefaultPresenter(interactor: interactor, router: router)
  }

  private func setupModule(error: Error) {
    router = AppConfigurationsRouterMock()
    let repository = AppConfigurationsRepositoryMock(usersProvider: createTraktProviderMock().users, isEmpty: true)
    let output = AppConfigurationsMock.AppConfigurationsOutputMock()
    let interactor = AppConfigurationsInteractorErrorMock(repository: repository, output: output)
    interactor.error = error
    presenter = AppConfigurationsDefaultPresenter(interactor: interactor, router: router)
  }

  private func setupModule(empty: Bool = false) {
    router = AppConfigurationsRouterMock()
    let repository = AppConfigurationsRepositoryMock(usersProvider: createTraktProviderMock().users, isEmpty: empty)
    let output = AppConfigurationsMock.AppConfigurationsOutputMock()
    interactor = AppConfigurationsInteractorMock(repository: repository, output: output)
    presenter = AppConfigurationsDefaultPresenter(interactor: interactor, router: router)
  }

  func testAppConfigurationsPresenter_receivesGenericError_notifyViewNotLogged() {
    // Given
    let message = "decrypt error"
    setUpModuleWithError(NSError(domain: "io.github.pietrocaselani", code: 203, userInfo: [NSLocalizedDescriptionKey: message]))

    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // When
    presenter.viewDidLoad()

    // Then
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connect to Trakt", subtitle: nil, value: .traktLogin(wantsToLogin: true))
    let traktViewModel = AppConfigurationsViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: false))
    let generalViewModel = AppConfigurationsViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let goToGithubViewModel = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel = AppConfigurationsViewModel(title: "Other", configurations: [goToGithubViewModel])

    let viewModels = [traktViewModel, generalViewModel, otherViewModel]

    let expectedEvents = [Recorded.next(0, AppConfigurationsViewState.loading),
                          Recorded.next(0, AppConfigurationsViewState.showing(configs: viewModels))]

    XCTAssertEqual(viewStateObserver.events, expectedEvents)
  }

  func testAppConfigurationsPresenter_receivesUserNotLoggedError_notifyView() {
    // Given
    setUpModuleWithError(AppConfigurationsMock.createUnauthorizedErrorMock())

    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // When
    presenter.viewDidLoad()

    // Then
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connect to Trakt", subtitle: nil, value: .traktLogin(wantsToLogin: true))
    let traktViewModel = AppConfigurationsViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: false))
    let generalViewModel = AppConfigurationsViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let goToGithubViewModel = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel = AppConfigurationsViewModel(title: "Other", configurations: [goToGithubViewModel])

    let viewModels = [traktViewModel, generalViewModel, otherViewModel]

    let expectedEvents = [Recorded.next(0, AppConfigurationsViewState.loading),
                          Recorded.next(0, AppConfigurationsViewState.showing(configs: viewModels))]

    XCTAssertEqual(viewStateObserver.events, expectedEvents)
  }

  func testAppConfigurationsPresenter_receivesUserLogged_notifyView() {
    // Given
    setupModule()

    _ = presenter.observeViewState().subscribe(viewStateObserver)

    // When
    presenter.viewDidLoad()

    // Then
    let expectedUserName = AppConfigurationsMock.createUserMock().name
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connected", subtitle: expectedUserName, value: .none)
    let traktViewModel = AppConfigurationsViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: false))
    let generalViewModel = AppConfigurationsViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let goToGithubViewModel = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel = AppConfigurationsViewModel(title: "Other", configurations: [goToGithubViewModel])

    let viewModels = [traktViewModel, generalViewModel, otherViewModel]

    let expectedEvents = [Recorded.next(0, AppConfigurationsViewState.loading),
                          Recorded.next(0, AppConfigurationsViewState.showing(configs: viewModels))]

    XCTAssertEqual(viewStateObserver.events, expectedEvents)
  }

  func testAppConfigurationsPresenter_receivesEventAlreadyConnectedToTraktFromView_doesNothing() {
    // Given
    setupModule()

    // When
    presenter.viewDidLoad()

    let connectToTrakt = AppConfigurationViewModel(title: "", subtitle: "", value: .none)
    presenter.select(configuration: connectToTrakt)

    // Then
    XCTAssertFalse(router.invokedShowTraktLogin)
  }

  func testAppConfigurationsPresenter_receivesEventConnectToTraktFromView_notifyRouter() {
    // Given
    setupModule(empty: true)
    presenter.viewDidLoad()

    // When
    let connectToTrakt = AppConfigurationViewModel(title: "", subtitle: "", value: .traktLogin(wantsToLogin: true))
    presenter.select(configuration: connectToTrakt)

    // Then
    XCTAssertTrue(router.invokedShowTraktLogin)
  }

  func testAppConfigurationsPresenter_receivesEventGoToGithubFromView_notifyRouter() {
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

  func testAppConfigurationsPresenter_receivesEventToggleHideSpecials_notifyInteractor() {
    // Given
    setupModule(empty: true)
    presenter.viewDidLoad()

    // When
    let connectToTrakt = AppConfigurationViewModel(title: "", subtitle: "", value: .hideSpecials(wantsToHideSpecials: false))
    presenter.select(configuration: connectToTrakt)

    // Then
    XCTAssertTrue(interactor.toggleHideSpecialsInvoked)
  }

  func testAppConfigurationsPresenter_receivesErrorFromInteractor_notifyRouter() {
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
    let expectedUserName = AppConfigurationsMock.createUserMock().name
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connected", subtitle: expectedUserName, value: .none)
    let traktViewModel = AppConfigurationsViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: false))
    let generalViewModel = AppConfigurationsViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let goToGithubViewModel = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel = AppConfigurationsViewModel(title: "Other", configurations: [goToGithubViewModel])

    let viewModels = [traktViewModel, generalViewModel, otherViewModel]

    let expectedEvents = [Recorded.next(0, AppConfigurationsViewState.loading),
                          Recorded.next(0, AppConfigurationsViewState.showing(configs: viewModels))]

    XCTAssertEqual(viewStateObserver.events, expectedEvents)
  }
}
