import RxSwift
import TraktSwift

public final class SearchDefaultPresenter: SearchPresenter {
  private let disposeBag = DisposeBag()
  private let searchStateSubject = BehaviorSubject<SearchState>(value: .notSearching)
  private let interactor: SearchInteractor
  private let schedulers: Schedulers
  private let router: SearchRouter
  private let searchTypes: [SearchType]
  private var currentPage = 0

  public init(interactor: SearchInteractor,
              types: [SearchType],
              router: SearchRouter,
              schedulers: Schedulers = DefaultSchedulers.instance) {
    self.interactor = interactor
    self.schedulers = schedulers
    self.router = router
    searchTypes = types
  }

  public func observeSearchState() -> Observable<SearchState> {
    return searchStateSubject.distinctUntilChanged()
  }

  public func search(query: String) {
    searchStateSubject.onNext(.searching)

    interactor.search(query: query, types: searchTypes, page: currentPage, limit: Defaults.itemsPerPage)
      .map { mapResultsToSearchState($0) }
      .catchError { Single.just(SearchState.error(error: $0)) }
      .observeOn(schedulers.mainScheduler)
      .subscribe(onSuccess: { [weak self] state in
        self?.searchStateSubject.onNext(state)
      }).disposed(by: disposeBag)
  }

  public func cancelSearch() {
    searchStateSubject.onNext(.notSearching)
  }

  public func select(entity: SearchResultEntity) {
    router.showViewFor(entity: entity)
  }
}

private func mapResultsToSearchState(_ results: [SearchResult]) -> SearchState {
  let entities = results.compactMap(mapResultToEntity(result:))
  guard entities.count > 0 else { return SearchState.emptyResults }
  return SearchState.results(entities: entities)
}

private func mapResultToEntity(result: SearchResult) -> SearchResultEntity? {
  switch result.type {
  case .show:
    guard let show = result.show else { return nil }
    return SearchResultEntity(score: result.score, type: .show(show: show))
  case .movie:
    guard let movie = result.movie else { return nil }
    return SearchResultEntity(score: result.score, type: .movie(movie: movie))
  default: return nil
  }
}
