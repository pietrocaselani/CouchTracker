import RxSwift
import Trakt

final class SearchiOSPresenter: SearchPresenter {
  private weak var view: SearchView?
  private let output: SearchResultOutput
  private let interactor: SearchInteractor
  private let disposeBag = DisposeBag()

  init(view: SearchView, interactor: SearchInteractor, resultOutput: SearchResultOutput) {
    self.view = view
    self.interactor = interactor
    self.output = resultOutput
  }

  func viewDidLoad() {
    view?.showHint(message: "Type a movie name".localized)
  }

  func searchMovies(query: String) {
    output.searchChangedTo(state: .searching)

    interactor.searchMovies(query: query)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] results in
          guard results.count > 0 else {
            self.output.handleEmptySearchResult()
            return
          }

          self.output.handleSearch(results: results)
        }, onError: { [unowned self] error in
          self.output.handleError(message: error.localizedDescription)
        }).disposed(by: disposeBag)
  }

  func cancelSearch() {
    output.searchChangedTo(state: .notSearching)
  }
}
