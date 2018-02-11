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
}

final class AppConfigurationsInteractorMock: AppConfigurationsInteractor {
  private let repository: AppConfigurationsRepository

  init(repository: AppConfigurationsRepository) {
    self.repository = repository
  }

  func fetchLoginState(forced: Bool) -> Observable<LoginState> {
    return repository.fetchLoginState(forced: forced).map { user -> LoginState in
      LoginState.logged(user: user)
      }.catchError { error in
        guard let moyaError = error as? MoyaError, moyaError.response?.statusCode == 401 else {
          return Observable.error(error)
        }

        return Observable.just(LoginState.notLogged)
    }
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

	init(dataSource: AppConfigurationsDataSource) {
		Swift.fatalError()
	}

	init(usersProvider: MoyaProvider<Users>, isEmpty: Bool = false, dataSource: AppConfigurationsDataSource = AppConfigurationDataSourceMock()) {
    self.usersProvider = usersProvider
    self.isEmpty = isEmpty
  }

  func fetchLoginState(forced: Bool) -> Observable<User> {
    guard !isEmpty else {
      return Observable.error(AppConfigurationsMock.createUnauthorizedErrorMock())
    }
    return usersProvider.rx.request(.settings).map(Settings.self).map { $0.user }.asObservable()
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

	func fetchLoginState(forced: Bool) -> Observable<User> {
    return Observable.error(error)
  }
}

final class AppConfigurationDataSourceMock: AppConfigurationsDataSource {
	var invokedSaveSettings = false
	var invokedFetchSettings = false
  var settings: Settings?

  func save(settings: Settings) throws {
	  invokedSaveSettings = true
    self.settings = settings
  }

  func fetchSettings() -> Observable<Settings> {
	  invokedFetchSettings = true

    guard let settings = settings else {
      return Observable.empty()
    }

    return Observable.just(settings)
  }
}
