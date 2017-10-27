import RxSwift
import Carlos
import Moya
import Moya_ObjectMapper
import Trakt

final class ShowDetailsCacheRepository: ShowDetailsRepository {
  private let cache: BasicCache<Shows, Show>

  init(traktProvider: TraktProvider) {
    let showsProvider = traktProvider.shows

    self.cache = MemoryCacheLevel<Shows, NSData>()
      .compose(MoyaFetcher(provider: showsProvider))
      .transformValues(JSONObjectTransfomer<Show>())
  }

  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show> {
    return cache.get(.summary(showId: identifier, extended: extended)).asObservable().asSingle()
  }
}
