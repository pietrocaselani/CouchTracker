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

  func fetchLoggedUser(forced: Bool) -> Observable<User> {
    let apiObservable = fetchSettingsFromAPI().map { $0.user }

    guard !forced else { return apiObservable }

    let cacheObservable = dataSource.fetchSettings().map { $0.user }

    return cacheObservable.catchError { _ in apiObservable }.ifEmpty(switchTo: apiObservable)
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
