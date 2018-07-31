import RxSwift
import TMDBSwift

public final class ConfigurationCachedRepository: ConfigurationRepository {
  private let tmdbProvider: TMDBProvider

  public init(tmdbProvider: TMDBProvider) {
    self.tmdbProvider = tmdbProvider
  }

  public func fetchConfiguration() -> Observable<Configuration> {
    return tmdbProvider.configuration.rx.request(.configuration)
      .map(Configuration.self)
      .asObservable()
  }
}
