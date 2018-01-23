import RxSwift
import TMDBSwift

final class ConfigurationCachedRepository: ConfigurationRepository {
  private let tmdbProvider: TMDBProvider

  init(tmdbProvider: TMDBProvider) {
    self.tmdbProvider = tmdbProvider
  }

  func fetchConfiguration() -> Observable<Configuration> {
    return tmdbProvider.configuration.rx.request(.configuration)
      .map(Configuration.self)
      .asObservable()
  }
}
