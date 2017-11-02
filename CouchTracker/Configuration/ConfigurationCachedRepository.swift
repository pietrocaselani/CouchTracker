import RxSwift
import TMDBSwift

final class ConfigurationCachedRepository: ConfigurationRepository {

//  private let cache: BasicCache<ConfigurationService, Configuration>
  private let tmdbProvider: TMDBProvider

  init(tmdbProvider: TMDBProvider) {
    self.tmdbProvider = tmdbProvider
//    self.cache = MemoryCacheLevel<ConfigurationService, NSData>()
//      .compose(DiskCacheLevel<ConfigurationService, NSData>())
//      .compose(MoyaFetcher(provider: tmdbProvider.configuration))
//      .transformValues(JSONObjectTransfomer<Configuration>())
  }

  func fetchConfiguration() -> Observable<Configuration> {
    return tmdbProvider.configuration.rx.request(.configuration)
      .map(Configuration.self)
      .asObservable()
  }
}
