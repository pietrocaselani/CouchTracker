import RxSwift
import Trakt
import Moya

final class AppConfigurationsService: AppConfigurationsInteractor {
  private let repository: AppConfigurationsRepository
  private let memoryCache: AnyCache<Int, NSData>
  private let diskCache: AnyCache<Int, NSData>

  init(repository: AppConfigurationsRepository, memoryCache: AnyCache<Int, NSData>, diskCache: AnyCache<Int, NSData>) {
    self.repository = repository
    self.memoryCache = memoryCache
    self.diskCache = diskCache
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

  func deleteCache() {
    memoryCache.clear()
    diskCache.clear()
  }
}
