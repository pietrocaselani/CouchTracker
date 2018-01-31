import RxSwift
import Moya
import TraktSwift

final class APISearchRepository: SearchRepository {
  private let trakt: TraktProvider
  private let scheduler: SchedulerType

  init(traktProvider: TraktProvider, scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
    self.trakt = traktProvider
    self.scheduler = scheduler
  }

  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    let target = Search.textQuery(types: types, query: query, page: page, limit: limit)

    return trakt.search.rx.request(target)
      .subscribeOn(scheduler)
      .observeOn(scheduler)
      .map([SearchResult].self)
      .asObservable()
  }
}
