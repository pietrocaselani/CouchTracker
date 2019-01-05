import RxSwift
import TraktSwift

public protocol SearchPresenter: class {
  func search(query: String)
  func cancelSearch()
  func select(entity: SearchResultEntity)
  func observeSearchState() -> Observable<SearchState>
}

public protocol SearchInteractor: class {
  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Single<[SearchResult]>
}

public protocol SearchRouter: class {
  func showViewFor(entity: SearchResultEntity)
}
