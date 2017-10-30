import RxSwift
import TraktSwift

protocol SearchView: BaseView {
  var presenter: SearchPresenter! { get set }

  func showHint(message: String)
}

protocol SearchResultOutput: class {
  func searchChangedTo(state: SearchState)
  func handleEmptySearchResult()
  func handleSearch(results: [SearchResult])
  func handleError(message: String)
}

protocol SearchPresenter: class {
  init(view: SearchView, interactor: SearchInteractor, resultOutput: SearchResultOutput)

  func viewDidLoad()
  func searchMovies(query: String)
  func cancelSearch()
}

protocol SearchInteractor: class {
  init(repository: SearchRepository)

  func searchMovies(query: String) -> Observable<[SearchResult]>
}

protocol SearchRepository: class {
  func search(query: String, types: [SearchType], page: Int, limit: Int) -> Observable<[SearchResult]>
}
