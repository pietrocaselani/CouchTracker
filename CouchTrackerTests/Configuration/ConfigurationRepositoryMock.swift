import RxSwift
import Moya
import TMDBSwift
import Moya_ObjectMapper

let configurationRepositoryMock = ConfigurationRepositoryMock(tmdbProvider: tmdbProviderMock)

final class ConfigurationRepositoryMock: ConfigurationRepository {
  private let provider: RxMoyaProvider<ConfigurationService>

  init(tmdbProvider: TMDBProvider) {
    self.provider = tmdbProvider.configuration
  }

  func fetchConfiguration() -> Observable<Configuration> {
    return provider.request(.configuration).mapObject(Configuration.self)
  }
}
