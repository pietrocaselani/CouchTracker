import RxSwift
import Moya
import TraktSwift

final class APISearchRepository: SearchRepository {
  private let trakt: TraktProvider
  private let schedulers: Schedulers

  init(traktProvider: TraktProvider, schedulers: Schedulers) {
    self.trakt = traktProvider
    self.schedulers = schedulers
  }

  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    let target = Search.textQuery(types: types, query: query, page: page, limit: limit)

    return trakt.search.rx.request(target)
      .observeOn(schedulers.networkScheduler)
      .map([SearchResult].self)
      .asObservable()
  }
}
