import RxSwift
import TraktSwift

public final class SearchDefaultPresenter: SearchPresenter {
  private let disposeBag = DisposeBag()
  private let searchStateSubject = BehaviorSubject<SearchState>(value: .notSearching)
  private let searchResultsSubject = BehaviorSubject<SearchResultState>(value: .emptyResults)
  private let interactor: SearchInteractor
  private let schedulers: Schedulers
  private let searchTypes: [SearchType]
  private var currentPage = 0

  public init(interactor: SearchInteractor, types: [SearchType], schedulers: Schedulers = DefaultSchedulers.instance) {
    self.interactor = interactor
    self.schedulers = schedulers
    searchTypes = types
  }

  public func observeSearchState() -> Observable<SearchState> {
    return searchStateSubject.distinctUntilChanged()
  }

  public func observeSearchResults() -> Observable<SearchResultState> {
    return searchResultsSubject.distinctUntilChanged()
  }

  public func search(query: String) {
    searchStateSubject.onNext(.searching)

    interactor.search(query: query, types: searchTypes, page: currentPage, limit: Defaults.itemsPerPage)
      .observeOn(schedulers.mainScheduler)
      .subscribe(onSuccess: { [weak self] results in
        self?.searchStateSubject.onNext(.notSearching)

        guard results.count > 0 else {
          self?.searchResultsSubject.onNext(.emptyResults)
          return
        }

        self?.searchResultsSubject.onNext(.results(results: results))

      }, onError: { [weak self] error in
        self?.searchStateSubject.onNext(.error(error: error))
      }).disposed(by: disposeBag)
  }

  public func cancelSearch() {
    searchStateSubject.onNext(.notSearching)
  }
}
