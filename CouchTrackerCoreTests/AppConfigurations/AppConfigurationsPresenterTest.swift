@testable import CouchTrackerCore
import Nimble
import RxSwift
import RxTest
import TraktSwift
import XCTest

final class AppStatePresenterTest: XCTestCase {
  private var router: AppStateRouterMock!
  private var presenter: AppStateDefaultPresenter!
  private var scheduler: TestSchedulers!
  private var manager: AppStateMock.AppStateManagerMock!
  private var viewStateObserver: TestableObserver<AppStateViewState>!

  override func tearDown() {
    super.tearDown()
    presenter = nil
    router = nil
    scheduler = nil
    viewStateObserver = nil
    manager = nil
  }

  override func setUp() {
    super.setUp()
    router = AppStateRouterMock()

    let testScheduler = TestScheduler(initialClock: 0)
    scheduler = TestSchedulers(mainScheduler: MainScheduler.instance, scheduler: testScheduler)
    viewStateObserver = scheduler.createObserver(AppStateViewState.self)
  }

  private func setupModule(error: Error) {
    manager = AppStateMock.AppStateManagerMock(error: error)
    presenter = AppStateDefaultPresenter(router: router, appStateManager: manager, schedulers: scheduler)
  }

  private func setupModule(empty: Bool = false) {
    let appState: AppState

    if empty {
      appState = AppState.initialState()
    } else {
      appState = AppState(userSettings: TraktEntitiesMock.createUserSettingsMock(), hideSpecials: true)
    }

    setupModule(appState: appState)
  }

  private func setupModule(appState: AppState) {
    manager = AppStateMock.AppStateManagerMock(appState: appState)
    presenter = AppStateDefaultPresenter(router: router, appStateManager: manager, schedulers: scheduler)
  }

  func testAppStatePresenter_receivesUserLogged_notifyView() {
    // Given
    setupModule(appState: AppStateMock.loggedAppState)

    // When
    presenter.viewDidLoad()

    let res = scheduler.start {
      self.presenter.observeViewState()
    }

    // Then
    let expectedUserName = AppStateMock.createUserMock().name
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connected", subtitle: expectedUserName, value: .none)
    let traktViewModel = AppStateViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: true))
    let generalViewModel = AppStateViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let goToGithubViewModel = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel = AppStateViewModel(title: "Other", configurations: [goToGithubViewModel])

    let viewModels = [traktViewModel, generalViewModel, otherViewModel]

    let expectedEvents = [Recorded.next(200, AppStateViewState.showing(configs: viewModels))]

    XCTAssertEqual(res.events, expectedEvents)
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

  func testAppStatePresenter_receivesEventToggleHideSpecials_notifyAppManager() {
    // Given
    setupModule(empty: false)
    presenter.viewDidLoad()

    // When
    let toggleHideSpecials = AppConfigurationViewModel(title: "", subtitle: "", value: .hideSpecials(wantsToHideSpecials: false))
    presenter.select(configuration: toggleHideSpecials)

    // Then
    XCTAssertEqual(manager.toggleHideSpecialsInvokeCount, 1)
  }

  func testAppStatePresenter_receivesErrorWhenToggleHideSpecials_notifyRouter() {
    // Given
    let error = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 2002, userInfo: nil)
    setupModule(error: error)

    presenter.viewDidLoad()

    // When
    let toggleHideSpecials = AppConfigurationViewModel(title: "", subtitle: "", value: .hideSpecials(wantsToHideSpecials: false))
    presenter.select(configuration: toggleHideSpecials)

    // Then
    expect(self.router.invokedShowErrorMessage).toEventually(beTrue())
  }

  func testAppConfigrationsPresenter_receivesNewAppState_updatesView() {
    // Given
    setupModule(empty: true)

    _ = presenter.observeViewState().subscribe(viewStateObserver)

    presenter.viewDidLoad()

    // When
    manager.change(state: AppStateMock.loggedAppState)

    // Then
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connect to Trakt", subtitle: nil, value: .traktLogin(wantsToLogin: true))
    let traktViewModel1 = AppStateViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: false))
    let generalViewModel1 = AppStateViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let goToGithubViewModel1 = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel1 = AppStateViewModel(title: "Other", configurations: [goToGithubViewModel1])

    let notLoggedViewModels = [traktViewModel1, generalViewModel1, otherViewModel1]

    let expectedUserName = AppStateMock.createUserMock().name
    let connectedViewModel = AppConfigurationViewModel(title: "Connected", subtitle: expectedUserName, value: .none)
    let traktViewModel2 = AppStateViewModel(title: "Trakt", configurations: [connectedViewModel])

    let hideSpecialsViewModel2 = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: true))
    let generalViewModel2 = AppStateViewModel(title: "General", configurations: [hideSpecialsViewModel2])

    let goToGithubViewModel2 = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel2 = AppStateViewModel(title: "Other", configurations: [goToGithubViewModel2])

    let loggedViewModels = [traktViewModel2, generalViewModel2, otherViewModel2]

    let expectedEvents = [Recorded.next(0, AppStateViewState.loading),
                          Recorded.next(0, AppStateViewState.showing(configs: notLoggedViewModels)),
                          Recorded.next(0, AppStateViewState.showing(configs: loggedViewModels))]

    XCTAssertEqual(viewStateObserver.events, expectedEvents)
  }
}
