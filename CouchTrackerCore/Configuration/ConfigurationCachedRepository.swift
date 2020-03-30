import RxSwift
import TMDBSwift

public final class ConfigurationCachedRepository: ConfigurationRepository {
  private let tmdbProvider: TMDBProvider
  private var cachedConfigurations: Configuration?

  public init(tmdbProvider: TMDBProvider) {
    self.tmdbProvider = tmdbProvider
  }

  public func fetchConfiguration() -> Observable<Configuration> {
    guard let configuration = cachedConfigurations else {
      return fetchConfigrationsFromAPI()
    }

    return Observable.just(configuration)
  }

  private func fetchConfigrationsFromAPI() -> Observable<Configuration> {
    tmdbProvider.configuration.rx.request(.configuration)
      .filterSuccessfulStatusAndRedirectCodes()
      .map(Configuration.self)
      .do(onSuccess: { [weak self] config in
        self?.cachedConfigurations = config
      })
      .asObservable()
  }
}
