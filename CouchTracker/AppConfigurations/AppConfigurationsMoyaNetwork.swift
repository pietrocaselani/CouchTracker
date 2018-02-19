import TraktSwift
import RxSwift

final class AppConfigurationsMoyaNetwork: AppConfigurationsNetwork {
  private let trakt: TraktProvider

  init(trakt: TraktProvider) {
    self.trakt = trakt
  }

  func fetchUserSettings() -> Single<Settings> {
    let target = Users.settings
    return trakt.users.rx.request(target).map(Settings.self)
  }
}
