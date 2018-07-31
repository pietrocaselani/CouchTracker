import RxSwift
import TraktSwift

public final class SearchDefaultPresenter: SearchPresenter {
  private weak var view: SearchView?
  private weak var output: SearchResultOutput?
  private let interactor: SearchInteractor
  private let searchTypes: [SearchType]
  private let disposeBag = DisposeBag()

  public init(view: SearchView, interactor: SearchInteractor, resultOutput: SearchResultOutput, types: [SearchType]) {
    self.view = view
    self.interactor = interactor
    output = resultOutput
    searchTypes = types
  }

  public func viewDidLoad() {
    view?.showHint(message: "Type something".localized)
  }

  public func search(query: String) {
    output?.searchChangedTo(state: .searching)

    interactor.search(query: query, types: searchTypes)
      .observeOn(MainScheduler.instance)
      .subscribe(onSuccess: { [weak self] results in
        guard results.count > 0 else {
          self?.output?.handleEmptySearchResult()
          return
        }

        self?.output?.handleSearch(results: results)
      }, onError: { [weak self] error in
        self?.output?.handleError(message: error.localizedDescription)
      }).disposed(by: disposeBag)
  }

  public func cancelSearch() {
    output?.searchChangedTo(state: .notSearching)
  }
}
