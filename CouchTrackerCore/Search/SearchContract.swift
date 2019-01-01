import RxSwift
import TraktSwift

public protocol SearchPresenter: class {
  func search(query: String)
  func cancelSearch()
  func observeSearchState() -> Observable<SearchState>
  func observeSearchResults() -> Observable<SearchResultState>
}

public protocol SearchInteractor: class {
  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Single<[SearchResult]>
}
