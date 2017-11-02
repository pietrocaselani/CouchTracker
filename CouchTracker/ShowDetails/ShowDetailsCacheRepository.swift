import RxSwift
import Moya
import TraktSwift

final class ShowDetailsCacheRepository: ShowDetailsRepository {
//  private let cache: BasicCache<Shows, Show>
  private let traktProvider: TraktProvider

  init(traktProvider: TraktProvider) {
//    let showsProvider = traktProvider.shows
    self.traktProvider = traktProvider

//    self.cache = MemoryCacheLevel<Shows, NSData>()
//      .compose(MoyaFetcher(provider: showsProvider))
//      .transformValues(JSONObjectTransfomer<Show>())
  }

  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show> {
    return traktProvider.shows.rx.request(.summary(showId: identifier, extended: extended)).map(Show.self)
  }
}
