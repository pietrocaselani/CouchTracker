import RxSwift
import TraktSwift

public final class SearchiOSPresenter: SearchPresenter {
	private weak var view: SearchView?
	private let output: SearchResultOutput
	private let interactor: SearchInteractor
	private let disposeBag = DisposeBag()

	public init(view: SearchView, interactor: SearchInteractor, resultOutput: SearchResultOutput) {
		self.view = view
		self.interactor = interactor
		self.output = resultOutput
	}

	public func viewDidLoad() {
		view?.showHint(message: "Type a movie name".localized)
	}

	public func searchMovies(query: String) {
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

	public func cancelSearch() {
		output.searchChangedTo(state: .notSearching)
	}
}
