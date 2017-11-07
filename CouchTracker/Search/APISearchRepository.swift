import RxSwift
import Moya
import TraktSwift

final class APISearchRepository: SearchRepository {
  private let trakt: TraktProvider

  init(traktProvider: TraktProvider) {
    self.trakt = traktProvider
  }

  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    let target = Search.textQuery(types: types, query: query, page: page, limit: limit)

    let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

    return trakt.search.rx.request(target)
      .subscribeOn(scheduler)
      .observeOn(scheduler)
      .map([SearchResult].self)
      .asObservable()
  }
}
