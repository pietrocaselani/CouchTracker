import TraktSwift
import RxSwift
import Moya

final class AppConfigurationsDefaultRepository: AppConfigurationsRepository {
  private let dataSource: AppConfigurationsDataSource
  private let trakt: TraktProvider

  init(dataSource: AppConfigurationsDataSource) {
    Swift.fatalError("please use init(dataSource: traktProvider:")
  }

  init(dataSource: AppConfigurationsDataSource, traktProvider: TraktProvider) {
    self.dataSource = dataSource
    self.trakt = traktProvider
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
    return trakt.users.rx.request(.settings)
      .filterSuccessfulStatusCodes()
      .map(Settings.self)
      .do(onSuccess: { [unowned self] settings in
        do {
          try self.dataSource.save(settings: settings)
        } catch {}
      }).asObservable()
  }
}
