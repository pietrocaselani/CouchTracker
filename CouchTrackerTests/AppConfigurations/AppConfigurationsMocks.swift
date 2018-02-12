import RxSwift
import TraktSwift
import Moya

final class AppConfigurationsMock {
  private init() {}

  static func createUserMock() -> User {
    return try! JSONDecoder().decode(Settings.self, from: Users.settings.sampleData).user
  }

  static func createUnauthorizedErrorMock() -> MoyaError {
    let response = Response(statusCode: 401, data: Data())
    return MoyaError.statusCode(response)
  }

  final class AppConfigurationsObservableMock: AppConfigurationsObservable {
    var subject = PublishSubject<AppConfigurationsState>()
    
    func chage(state: AppConfigurationsState) {
      subject.onNext(state)
    }

    func observe() -> Observable<AppConfigurationsState> {
      return subject.asObservable()
    }
  }

  final class AppConfigurationsOutputMock: AppConfigurationsOutput {
    var newConfigurationInvoked = false
    var newConfigurationParameters: AppConfigurationsState?

    func newConfiguration(state: AppConfigurationsState) {
      newConfigurationInvoked = true
      newConfigurationParameters = state
    }
  }
}

final class AppConfigurationsInteractorMock: AppConfigurationsInteractor {
  private let repository: AppConfigurationsRepository
  var hideSpecials = false
  var loginState = LoginState.notLogged

  init(repository: AppConfigurationsRepository, output: AppConfigurationsOutput) {
    self.repository = repository
  }

  func fetchAppConfigurationsState(forced: Bool) -> Observable<AppConfigurationsState> {
    let hideSpecial = repository.fetchHideSpecials()
    let loginState = repository.fetchLoginState(forced: forced)

    return Observable.combineLatest(loginState, hideSpecial, resultSelector: { (loginState, hideSpecials) -> AppConfigurationsState in
      return AppConfigurationsState(loginState: loginState, hideSpecials: hideSpecials)
    }).catchErrorJustReturn(AppConfigurationsState.initialState())
  }

  func toggleHideSpecials() -> Completable {
    return repository.toggleHideSpecials()
  }
}

final class AppConfigurationsViewMock: AppConfigurationsView {
  var presenter: AppConfigurationsPresenter!
  var invokedShowConfigurations = false
  var invokedShowConfigurationsParameters: (models: [AppConfigurationsViewModel], Void)?

  func showConfigurations(models: [AppConfigurationsViewModel]) {
    invokedShowConfigurations = true
    invokedShowConfigurationsParameters = (models, ())
  }
}

final class AppConfigurationsRouterMock: AppConfigurationsRouter {
  var invokedShowTraktLogin = false
  var invokedShowErrorMessage = false
  var invokedShowErrorMessageParameters: (message: String, Void)?

  func showTraktLogin(output: TraktLoginOutput) {
    invokedShowTraktLogin = true
  }

  func showError(message: String) {
    invokedShowErrorMessage = true
    invokedShowErrorMessageParameters = (message, ())
  }
}

final class AppConfigurationsRepositoryMock: AppConfigurationsRepository {
  private let usersProvider: MoyaProvider<Users>
  private let isEmpty: Bool
  var invokedSaveSettings = false
  var invokedFetchSettings = false
  var hideSpecials = false
  var invokedToggleHideSpecials = false
  var invokedFetchHideSpecials = false

	init(dataSource: AppConfigurationsDataSource) {
		Swift.fatalError()
	}

	init(usersProvider: MoyaProvider<Users>, isEmpty: Bool = false, dataSource: AppConfigurationsDataSource = AppConfigurationDataSourceMock()) {
    self.usersProvider = usersProvider
    self.isEmpty = isEmpty
  }

  func fetchHideSpecials() -> Observable<Bool> {
    invokedFetchHideSpecials = true
    return Observable.just(hideSpecials)
  }

  func toggleHideSpecials() -> Completable {
    invokedToggleHideSpecials = true
    hideSpecials = !hideSpecials
    return Completable.empty()
  }

  func fetchLoginState(forced: Bool) -> Observable<LoginState> {
    invokedFetchSettings = true

    guard !isEmpty else { return Observable.just(LoginState.notLogged) }

    return usersProvider.rx.request(.settings).map(Settings.self).asObservable().map { LoginState.logged(settings: $0) }
  }
}

final class AppConfigurationsRepositoryErrorMock: AppConfigurationsRepository {
  private let error: Swift.Error

	init(dataSource: AppConfigurationsDataSource) {
		Swift.fatalError()
	}

  init(error: Swift.Error, dataSource: AppConfigurationsDataSource = AppConfigurationDataSourceMock()) {
	  self.error = error
  }

  func fetchLoginState(forced: Bool) -> Observable<LoginState> {
    return Observable.error(error)
  }

  func fetchHideSpecials() -> Observable<Bool> {
    return Observable.error(error)
  }

  func toggleHideSpecials() -> Completable {
    return Completable.error(error)
  }
}

final class AppConfigurationDataSourceMock: AppConfigurationsDataSource {
  var invokedSaveSettings = false
	var invokedFetchLoginState = false
  var hideSpecials = false
  var invokedToggleHideSpecials = false
  var invokedFetchHideSpecials = false
  var settings: Settings?

  func save(settings: Settings) throws {
	  invokedSaveSettings = true
    self.settings = settings
  }

  func fetchLoginState() -> Observable<LoginState> {
    invokedFetchLoginState = true

    guard let settings = settings else { return Observable.just(LoginState.notLogged) }

    return Observable.just(LoginState.logged(settings: settings))
  }

  func toggleHideSpecials() throws {
    invokedToggleHideSpecials = true
    hideSpecials = !hideSpecials
  }

  func fetchHideSpecials() -> Observable<Bool> {
    invokedFetchHideSpecials = true
    return Observable.just(hideSpecials)
  }
}
