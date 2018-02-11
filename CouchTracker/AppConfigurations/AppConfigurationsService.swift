import RxSwift
import TraktSwift
import Moya

final class AppConfigurationsService: AppConfigurationsInteractor {
  private let repository: AppConfigurationsRepository
  private let output: AppConfigurationsOutput

  init(repository: AppConfigurationsRepository, output: AppConfigurationsOutput) {
    self.repository = repository
    self.output = output
  }

  func fetchAppConfigurationsState(forced: Bool) -> Observable<AppConfigurationsState> {
    let loginStateObservable = fetchLoginState(forced: forced)
    let hideSpecialsObservable = fetchHideSpecials()

    return Observable.combineLatest(loginStateObservable, hideSpecialsObservable) { (loginState, hideSpecials) in
      AppConfigurationsState(loginState: loginState, hideSpecials: hideSpecials)
      }.catchErrorJustReturn(AppConfigurationsState.initialState())
      .do(onNext: { [unowned self] newState in
        self.output.newConfiguration(state: newState)
      })
  }

  func toggleHideSpecials() -> Completable {
    return self.repository.toggleHideSpecials()
  }

  private func fetchLoginState(forced: Bool) -> Observable<LoginState> {
    return repository.fetchLoginState(forced: forced)
      .catchError { error in
        guard let moyaError = error as? MoyaError, moyaError.response?.statusCode == 401 else {
          return Observable.error(error)
        }

        return Observable.just(LoginState.notLogged)
    }
  }

  private func fetchHideSpecials() -> Observable<Bool> {
    return repository.fetchHideSpecials()
  }
}
