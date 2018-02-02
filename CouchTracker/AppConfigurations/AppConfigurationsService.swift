import RxSwift
import TraktSwift
import Moya

final class AppConfigurationsService: AppConfigurationsInteractor {
  private let repository: AppConfigurationsRepository

  init(repository: AppConfigurationsRepository) {
    self.repository = repository
  }

  func fetchLoginState(forced: Bool) -> Observable<LoginState> {
    return repository.fetchLoggedUser(forced: forced).map { user -> LoginState in
      return LoginState.logged(user: user)
    }.catchError { error in
      guard let moyaError = error as? MoyaError, moyaError.response?.statusCode == 401 else {
        return Observable.error(error)
      }

      return Observable.just(LoginState.notLogged)
    }
  }
}
