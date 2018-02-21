import RxSwift
import Moya
import TMDBSwift
@testable import CouchTrackerCore

let configurationRepositoryMock = ConfigurationRepositoryMock(tmdbProvider: tmdbProviderMock)

final class ConfigurationRepositoryMock: ConfigurationRepository {
	private let provider: MoyaProvider<ConfigurationService>

	init(tmdbProvider: TMDBProvider) {
		self.provider = tmdbProvider.configuration
	}

	func fetchConfiguration() -> Observable<Configuration> {
		return provider.rx.request(.configuration).map(Configuration.self).asObservable()
	}
}
