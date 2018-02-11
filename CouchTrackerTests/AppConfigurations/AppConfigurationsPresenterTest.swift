import XCTest
import TraktSwift

final class AppConfigurationsPresenterTest: XCTestCase {
  private var view: AppConfigurationsViewMock!
  private var router: AppConfigurationsRouterMock!
  private var presenter: AppConfigurationsPresenter!

  override func tearDown() {
    super.tearDown()
    presenter = nil
    view = nil
    router = nil
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
    presenter = AppConfigurationsiOSPresenter(view: view, interactor: interactor, router: router)
  }

  private func setupModule(empty: Bool = false)  {
    view = AppConfigurationsViewMock()
    router = AppConfigurationsRouterMock()
    let repository = AppConfigurationsRepositoryMock(usersProvider: traktProviderMock.users, isEmpty: empty)
    let output = AppConfigurationsMock.AppConfigurationsOutputMock()
    let interactor = AppConfigurationsInteractorMock(repository: repository, output: output)
    presenter = AppConfigurationsiOSPresenter(view: view, interactor: interactor, router: router)
  }

  func testAppConfigurationsPresenter_receivesGenericError_notifyViewNotLogged() {
    //Given
    let message = "decrypt error"
    setUpModuleWithError(NSError(domain: "io.github.pietrocaselani", code: 203, userInfo: [NSLocalizedDescriptionKey: message]))

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(view.invokedShowConfigurations)

    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connect to Trakt", subtitle: nil, value: .none)
    let traktViewModel = AppConfigurationsViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .boolean(value: false))
    let generalViewModel = AppConfigurationsViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let viewModels = [traktViewModel, generalViewModel]

    if view.invokedShowConfigurationsParameters?.models == nil {
      XCTFail("Parameters can't be nil")
    } else {
      XCTAssertEqual(view.invokedShowConfigurationsParameters!.models, viewModels)
    }
  }

  func testAppConfigurationsPresenter_receivesUserNotLoggedError_notifyView() {
    //Given
    setUpModuleWithError(AppConfigurationsMock.createUnauthorizedErrorMock())

    //When
    presenter.viewDidLoad()

    //Then
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connect to Trakt", subtitle: nil, value: .none)
    let traktViewModel = AppConfigurationsViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .boolean(value: false))
    let generalViewModel = AppConfigurationsViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let viewModels = [traktViewModel, generalViewModel]

    XCTAssertTrue(view.invokedShowConfigurations)
    if view.invokedShowConfigurationsParameters?.models == nil {
      XCTFail("Parameters can't be nil")
    } else {
      XCTAssertEqual(view.invokedShowConfigurationsParameters!.models, viewModels)
    }
  }

  func testAppConfigurationsPresenter_receivesUserLogged_notifyView() {
    //Given
    setupModule()

    //When
    presenter.viewDidLoad()

    //Then
    let expectedUserName = AppConfigurationsMock.createUserMock().name
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connected", subtitle: expectedUserName, value: .none)
    let traktViewModel = AppConfigurationsViewModel(title: "Trakt", configurations: [connectToTraktViewModel])

    let hideSpecialsViewModel = AppConfigurationViewModel(title: "Hide specials", subtitle: "Will not show special episodes", value: .boolean(value: false))
    let generalViewModel = AppConfigurationsViewModel(title: "General", configurations: [hideSpecialsViewModel])

    let viewModels = [traktViewModel, generalViewModel]

    XCTAssertTrue(view.invokedShowConfigurations)

    if view.invokedShowConfigurationsParameters?.models == nil {
      XCTFail("Parameters can't be nil")
    } else {
      XCTAssertEqual(view.invokedShowConfigurationsParameters!.models, viewModels)
    }
  }

  func testAppConfigurationsPresenter_receivesEventAlreadyConnectedToTraktFromView_doesNothing() {
    //Given
    setupModule()

    //When
    presenter.viewDidLoad()
    presenter.optionSelectedAt(index: 0)

    //Then
    XCTAssertFalse(router.invokedShowTraktLogin)
  }

  func testAppConfigurationsPresenter_receivesEventConnectToTraktFromView_notifyRouter() {
    //Given
    setupModule(empty: true)
    presenter.viewDidLoad()

    //When
    presenter.optionSelectedAt(index: 0)

    //Then
    XCTAssertTrue(router.invokedShowTraktLogin)
  }
}
