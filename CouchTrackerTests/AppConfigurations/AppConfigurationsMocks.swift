import RxSwift
import Trakt
import Moya

final class AppConfigurationsMock {
  private init() {}

  static func createUserMock() -> User {
    return try! Settings(JSON: JSONParser.toObject(data: Users.settings.sampleData)).user
  }

  static func createUnauthorizedErrorMock() -> MoyaError {
    let response = Response(statusCode: 401, data: Data())
    return MoyaError.statusCode(response)
  }
}

final class AppConfigurationsInteractorMock: AppConfigurationsInteractor {
  private let repository: AppConfigurationsRepository

  init(repository: AppConfigurationsRepository, memoryCache: AnyCache<Int, NSData>, diskCache: AnyCache<Int, NSData>) {
    self.repository = repository
  }

  func fetchLoginState(forced: Bool) -> Observable<LoginState> {
    return repository.fetchLoggedUser(forced: forced).map { user -> LoginState in
      LoginState.logged(user: user)
      }.catchError { error in
        guard let moyaError = error as? MoyaError, moyaError.response?.statusCode == 401 else {
          return Observable.error(error)
        }

        return Observable.just(LoginState.notLogged)
    }
  }

  func deleteCache() {
    
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
  private let usersProvider: RxMoyaProvider<Users>
  private let isEmpty: Bool
  init(usersProvider: RxMoyaProvider<Users>, isEmpty: Bool = false) {
    self.usersProvider = usersProvider
    self.isEmpty = isEmpty
    preferredContentLocale = Locale.current
  }

  var preferredContentLocale: Locale

  var preferredLocales: [Locale] {
    return Locale.preferredLanguages.map { Locale(identifier: $0) }
  }

  func fetchLoggedUser(forced: Bool) -> Observable<User> {
    guard !isEmpty else {
      return Observable.error(AppConfigurationsMock.createUnauthorizedErrorMock())
    }
    return usersProvider.request(.settings).mapObject(Settings.self).map { $0.user }
  }
}

final class AppConfigurationsRepositoryErrorMock: AppConfigurationsRepository {
  private let error: Swift.Error

  init(error: Swift.Error) {
    self.error = error
    preferredContentLocale = Locale.current
  }

  var preferredLocales: [Locale] { return Locale.preferredLanguages.map { Locale(identifier: $0) } }

  var preferredContentLocale: Locale

  func fetchLoggedUser(forced: Bool) -> Observable<User> {
    return Observable.error(error)
  }
}
