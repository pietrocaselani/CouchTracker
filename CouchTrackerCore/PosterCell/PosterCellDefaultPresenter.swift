import RxSwift

public final class PosterCellDefaultPresenter: PosterCellPresenter {
	private weak var view: PosterCellView?
	private let interactor: PosterCellInteractor
	private let viewModel: PosterViewModel
	private let disposeBag = DisposeBag()

	public init(view: PosterCellView, interactor: PosterCellInteractor, viewModel: PosterViewModel) {
		self.view = view
		self.interactor = interactor
		self.viewModel = viewModel
	}

	public func viewWillAppear() {
		view?.show(viewModel: PosterCellViewModel(title: viewModel.title))

		guard let trendingType = viewModel.type else { return }

		interactor.fetchPosterImageURL(of: trendingType, with: .w185)
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { imageURL in
				guard let view = self.view else { return }

				view.showPosterImage(with: imageURL)
			}, onError: { error in
				print(error)
			}).disposed(by: disposeBag)
	}
}
