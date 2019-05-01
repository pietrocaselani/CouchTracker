import RxSwift
import TraktSwift

public protocol SearchPresenter: AnyObject {
  func search(query: String)
  func cancelSearch()
  func select(entity: SearchResultEntity)
  func observeSearchState() -> Observable<SearchState>
}

public protocol SearchInteractor: AnyObject {
  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Single<[SearchResult]>
}

public protocol SearchRouter: AnyObject {
  func showViewFor(entity: SearchResultEntity)
}
