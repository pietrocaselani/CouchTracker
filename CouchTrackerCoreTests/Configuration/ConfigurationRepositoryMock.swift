@testable import CouchTrackerCore
import Moya
import RxSwift
import TMDBSwift

let configurationRepositoryMock = ConfigurationRepositoryMock(tmdbProvider: tmdbProviderMock)

final class ConfigurationRepositoryMock: ConfigurationRepository {
    private let provider: MoyaProvider<ConfigurationService>

    init(tmdbProvider: TMDBProvider) {
        provider = tmdbProvider.configuration
    }

    func fetchConfiguration() -> Observable<Configuration> {
        return provider.rx.request(.configuration).map(Configuration.self).asObservable()
    }
}
