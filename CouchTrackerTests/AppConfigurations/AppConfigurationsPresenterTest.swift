import XCTest
import Trakt

final class AppConfigurationsPresenterTest: XCTestCase {
  private let cache = CacheMock()
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
    let interactor = AppConfigurationsInteractorMock(repository: repository, memoryCache: AnyCache(cache), diskCache: AnyCache(cache))
    presenter = AppConfigurationsiOSPresenter(view: view, interactor: interactor, router: router)
  }

  private func setupModule(empty: Bool = false)  {
    view = AppConfigurationsViewMock()
    router = AppConfigurationsRouterMock()
    let repository = AppConfigurationsRepositoryMock(usersProvider: traktProviderMock.users, isEmpty: empty)
    let interactor = AppConfigurationsInteractorMock(repository: repository, memoryCache: AnyCache(cache), diskCache: AnyCache(cache))
    presenter = AppConfigurationsiOSPresenter(view: view, interactor: interactor, router: router)
  }

  func testAppConfigurationsPresenter_receivesGenericError_notifyRouter() {
    //Given
    let message = "decrypt error"
    setUpModuleWithError(NSError(domain: "com.arctouch", code: 203, userInfo: [NSLocalizedDescriptionKey: message]))

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(router.invokedShowErrorMessage)
    XCTAssertEqual(router.invokedShowErrorMessageParameters?.message, message)
  }

  func testAppConfigurationsPresenter_receivesUserNotLoggedError_notifyView() {
    //Given
    setUpModuleWithError(AppConfigurationsMock.createUnauthorizedErrorMock())

    //When
    presenter.viewDidLoad()

    //Then
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connect to Trakt", subtitle: nil)
    let viewModels = [AppConfigurationsViewModel(title: "Trakt", configurations: [connectToTraktViewModel])]

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
    let connectToTraktViewModel = AppConfigurationViewModel(title: "Connected", subtitle: expectedUserName)
    let viewModels = [AppConfigurationsViewModel(title: "Trakt", configurations: [connectToTraktViewModel])]

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
    sleep(1)
    presenter.optionSelectedAt(index: 0)

    //Then
    XCTAssertTrue(router.invokedShowTraktLogin)
  }
}
