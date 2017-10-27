import Carlos
import RxSwift
import TMDBSwift

final class ConfigurationCachedRepository: ConfigurationRepository {

  private let cache: BasicCache<ConfigurationService, Configuration>

  init(tmdbProvider: TMDBProvider) {
    self.cache = MemoryCacheLevel<ConfigurationService, NSData>()
      .compose(DiskCacheLevel<ConfigurationService, NSData>())
      .compose(MoyaFetcher(provider: tmdbProvider.configuration))
      .transformValues(JSONObjectTransfomer<Configuration>())
  }

  func fetchConfiguration() -> Observable<Configuration> {
    let scheduler = SerialDispatchQueueScheduler(qos: .background)
    return cache.get(.configuration).asObservable().subscribeOn(scheduler).observeOn(scheduler)
  }
}
