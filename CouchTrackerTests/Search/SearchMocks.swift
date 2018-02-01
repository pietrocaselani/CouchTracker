import Moya
import RxSwift
import TraktSwift

final class SearchViewMock: SearchView {
  var presenter: SearchPresenter!
  var invokedShowHint = false
  var invokedShowHintParameters: (message: String, Void)?

  func showHint(message: String) {
    invokedShowHint = true
    invokedShowHintParameters = (message, ())
  }
}

final class SearchResultOutputMock: SearchResultOutput {
  var invokedHandleEmptySearchResult = false

  func handleEmptySearchResult() {
    invokedHandleEmptySearchResult = true
  }

  var invokedHandleSearch = false
  var invokedHandleSearchParameters: (results: [SearchResult], Void)?

  func handleSearch(results: [SearchResult]) {
    invokedHandleSearch = true
    invokedHandleSearchParameters = (results, ())
  }

  var invokedHandleError = false
  var invokedHandleErrorParameters: (message: String, Void)?

  func handleError(message: String) {
    invokedHandleError = true
    invokedHandleErrorParameters = (message, ())
  }

  var searchState = SearchState.notSearching

  func searchChangedTo(state: SearchState) {
    searchState = state
  }
}

final class EmptySearchStoreMock: SearchRepository {
  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    return Observable.just([SearchResult]())
  }
}

final class ErrorSearchStoreMock: SearchRepository {
  private let error: Swift.Error

  init(error: Swift.Error) {
    self.error = error
  }

  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    return Observable.error(error)
  }
}

final class SearchStoreMock: SearchRepository {
  private let results: [SearchResult]

  init(results: [SearchResult]) {
    self.results = results
  }

  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    return Observable.just(results).take(limit)
  }
}

final class SearchInteractorMock: SearchInteractor {
  private let repository: SearchRepository

  init(repository: SearchRepository) {
    self.repository = repository
  }

  func searchMovies(query: String) -> Observable<[SearchResult]> {
    let lowercaseQuery = query.lowercased()

    return repository.search(query: query, types: [.movie], page: 0, limit: 50).map { results -> [SearchResult] in
      results.filter { result -> Bool in
        let containsMovie = result.movie?.title?.lowercased().contains(lowercaseQuery) ?? false
        let containsShow = result.show?.title?.lowercased().contains(lowercaseQuery) ?? false
        return containsMovie || containsShow
      }
    }
  }
}

final class SearchRepositoryAPIStubMock: SearchRepository {
  private let searchProvider: MoyaProvider<Search>

  init() {
    searchProvider = traktProviderMock.search
  }

  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]> {
    let target = Search.textQuery(types: types, query: query, page: page, limit: limit)
    return searchProvider.rx.request(target).map([SearchResult].self).asObservable()
  }
}
