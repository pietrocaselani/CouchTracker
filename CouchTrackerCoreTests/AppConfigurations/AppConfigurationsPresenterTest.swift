@testable import CouchTrackerCore
import TraktSwift
import XCTest

final class AppConfigurationsPresenterTest: XCTestCase {
  private var view: AppConfigurationsViewMock!
  private var router: AppConfigurationsRouterMock!
  private var presenter: AppConfigurationsDefaultPresenter!
  private var interactor: AppConfigurationsInteractorMock!
  private var interactorError: AppConfigurationsInteractorErrorMock!

  override func tearDown() {
    super.tearDown()
    presenter = nil
    view = nil
    router = nil
    interactor = nil
  }

  override func setUp() {
    super.setUp()
    view = AppConfigurationsViewMock()
    router = AppConfigurationsRouterMock()
  }

  private func setUpModuleWithError(_ error: Error) {
    let repository = AppConfigurationsRepositoryErrorMock(error: error)
    let output = AppConfigurationsMock.AppConfigurationsOutputMock()
    let interactor = AppConfigurationsInteractorMock(repository: repository, output: output)
    presenter = AppConfigurationsDefaultPresenter(view: view, interactor: interactor, router: router)
  }

  private func setupModule(error: Error) {
    view = AppConfigurationsViewMock()
    router = AppConfigurationsRouterMock()
    let repository = AppConfigurationsRepositoryMock(usersProvider: createTraktProviderMock().users, isEmpty: true)
    let output = AppConfigurationsMock.AppConfigurationsOutputMock()
    let interactor = AppConfigurationsInteractorErrorMock(repository: repository, output: output)
    interactor.error = error
    presenter = AppConfigurationsDefaultPresenter(view: view, interactor: interactor, router: router)
  }

  private func setupModule(empty: Bool = false) {
    view = AppConfigurationsViewMock()
    router = AppConfigurationsRouterMock()
    let repository = AppConfigurationsRepositoryMock(usersProvider: createTraktProviderMock().users, isEmpty: empty)
    let output = AppConfigurationsMock.AppConfigurationsOutputMock()
    interactor = AppConfigurationsInteractorMock(repository: repository, output: output)
    presenter = AppConfigurationsDefaultPresenter(view: view, interactor: interactor, router: router)
  }

  func testAppConfigurationsPresenter_receivesGenericError_notifyViewNotLogged() {
    // Given
    let message = "decrypt error"
    setUpModuleWithError(NSError(domain: "io.github.pietrocaselani", code: 203, userInfo: [NSLocalizedDescriptionKey: message]))

    // When
    presenter.viewDidLoad()

    // Then
    XCTAssertTrue(view.invokedShowConfigurations)

    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connect to Trakt", subtitle: nil, value: .none)
    let traktViewModel = AppConfigurationsViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: false))
    let generalViewModel = AppConfigurationsViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let goToGithubViewModel = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel = AppConfigurationsViewModel(title: "Other", configurations: [goToGithubViewModel])

    let viewModels = [traktViewModel, generalViewModel, otherViewModel]

    if view.invokedShowConfigurationsParameters?.models == nil {
      XCTFail("Parameters can't be nil")
    } else {
      XCTAssertEqual(view.invokedShowConfigurationsParameters!.models, viewModels)
    }
  }

  func testAppConfigurationsPresenter_receivesUserNotLoggedError_notifyView() {
    // Given
    setUpModuleWithError(AppConfigurationsMock.createUnauthorizedErrorMock())

    // When
    presenter.viewDidLoad()

    // Then
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connect to Trakt", subtitle: nil, value: .none)
    let traktViewModel = AppConfigurationsViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .hideSpecials(wantsToHideSpecials: false))
    let generalViewModel = AppConfigurationsViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let goToGithubViewModel = AppConfigurationViewModel(title: "CouchTracker on GitHub", value: .externalURL(url: Constants.githubURL))
    let otherViewModel = AppConfigurationsViewModel(title: "Other", configurations: [goToGithubViewModel])

    let viewModels = [traktViewModel, generalViewModel, otherViewModel]

    XCTAssertTrue(view.invokedShowConfigurations)
    if view.invokedShowConfigurationsParameters?.models == nil {
      XCTFail("Parameters can't be nil")
    } else {
      XCTAssertEqual(view.invokedShowConfigurationsParameters!.models, viewModels)
    }
  }

  func testAppConfigurationsPresenter_receivesUserLogged_notifyView() {
    // Given
    setupModule()

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

    XCTAssertTrue(view.invokedShowConfigurations)

    if view.invokedShowConfigurationsParameters?.models == nil {
      XCTFail("Parameters can't be nil")
    } else {
      XCTAssertEqual(view.invokedShowConfigurationsParameters!.models, viewModels)
    }
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
    setupModule(empty: true)

    // When
    presenter.loggedInSuccessfully()

    // Then
    XCTAssertTrue(view.invokedShowConfigurations)
  }
}
