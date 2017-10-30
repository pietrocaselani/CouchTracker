import RxSwift
import Moya
import Moya_ObjectMapper
import TraktSwift

final class APISearchRepository: SearchRepository {

  private let provider: RxMoyaProvider<Search>

  init(traktProvider: TraktProvider) {
    self.provider = traktProvider.search
  }

  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    let target = Search.textQuery(types: types, query: query, page: page, limit: limit)

    let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

    return provider.request(target)
      .subscribeOn(scheduler)
      .observeOn(scheduler)
      .mapArray(SearchResult.self)
  }
}
