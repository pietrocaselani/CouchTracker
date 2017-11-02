import RxSwift
import Moya
import TraktSwift

final class APISearchRepository: SearchRepository {

  private let provider: MoyaProvider<Search>

  init(traktProvider: TraktProvider) {
    self.provider = traktProvider.search
  }

  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    let target = Search.textQuery(types: types, query: query, page: page, limit: limit)

    let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

    return provider.rx.request(target)
      .subscribeOn(scheduler)
      .observeOn(scheduler)
      .map([SearchResult].self)
      .asObservable()
  }
}
