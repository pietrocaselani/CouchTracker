import RxSwift
import TraktSwift

public protocol SearchView: BaseView {
    var presenter: SearchPresenter! { get set }

    func showHint(message: String)
}

public protocol SearchResultOutput: class {
    func searchChangedTo(state: SearchState)
    func handleEmptySearchResult()
    func handleSearch(results: [SearchResult])
    func handleError(message: String)
}

public protocol SearchPresenter: class {
    init(view: SearchView, interactor: SearchInteractor, resultOutput: SearchResultOutput, types: [SearchType])

    func viewDidLoad()
    func search(query: String)
    func cancelSearch()
}

public protocol SearchInteractor: class {
    init(repository: SearchRepository)

    func search(query: String, types: [SearchType]) -> Single<[SearchResult]>
}

public protocol SearchRepository: class {
    func search(query: String, types: [SearchType], page: Int, limit: Int) -> Single<[SearchResult]>
}

public enum SearchState {
    case searching
    case notSearching
}
