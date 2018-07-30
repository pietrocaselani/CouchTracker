import RxSwift
import TraktSwift

public final class AppConfigurationsMoyaNetwork: AppConfigurationsNetwork {
    private let trakt: TraktProvider

    public init(trakt: TraktProvider) {
        self.trakt = trakt
    }

    public func fetchUserSettings() -> Single<Settings> {
        let target = Users.settings
        return trakt.users.rx.request(target).map(Settings.self)
    }
}
