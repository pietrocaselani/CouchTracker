import TraktSwift
import RxSwift
import Moya

final class AppConfigurationsDefaultRepository: AppConfigurationsRepository {
  private let dataSource: AppConfigurationsDataSource
  private let network: AppConfigurationsNetwork

  init(dataSource: AppConfigurationsDataSource, network: AppConfigurationsNetwork) {
    self.dataSource = dataSource
    self.network = network
  }

  func fetchLoginState(forced: Bool) -> Observable<LoginState> {
    let apiObservable = fetchSettingsFromAPI()
      .map { LoginState.logged(settings: $0) }
      .ifEmpty(default: LoginState.notLogged)
      .catchErrorJustReturn(LoginState.notLogged)

    guard !forced else { return apiObservable }

    return dataSource.fetchLoginState()
      .catchError { _ in apiObservable }
      .ifEmpty(switchTo: apiObservable)
  }

  func fetchHideSpecials() -> Observable<Bool> {
    return dataSource.fetchHideSpecials()
  }

  func toggleHideSpecials() -> Completable {
    return Completable.create(subscribe: { [unowned self] completable -> Disposable in
      do {
        try self.dataSource.toggleHideSpecials()
        completable(.completed)
      } catch {
        completable(.error(error))
      }

      return Disposables.create()
    })
  }

  private func fetchSettingsFromAPI() -> Observable<Settings> {
    return network.fetchUserSettings()
      .do(onSuccess: { [unowned self] settings in
        do {
          try self.dataSource.save(settings: settings)
        } catch {}
      }).asObservable()
  }
}
