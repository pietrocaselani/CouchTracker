import RxSwift

public final class ShowProgressCellDefaultPresenter: ShowProgressCellPresenter {
	private weak var view: ShowProgressCellView?
	private let interactor: ShowProgressCellInteractor
	private let viewModel: WatchedShowViewModel
	private let disposeBag = DisposeBag()

	public init(view: ShowProgressCellView, interactor: ShowProgressCellInteractor, viewModel: WatchedShowViewModel) {
		self.view = view
		self.interactor = interactor
		self.viewModel = viewModel
	}

	public func viewWillAppear() {
		view?.show(viewModel: viewModel)

		guard let tmdbId = viewModel.tmdbId else { return }

		interactor.fetchPosterImageURL(for: tmdbId, with: .w185)
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [weak self] url in
				guard let view = self?.view else { return }

				view.showPosterImage(with: url)
			}).disposed(by: disposeBag)
	}
}
