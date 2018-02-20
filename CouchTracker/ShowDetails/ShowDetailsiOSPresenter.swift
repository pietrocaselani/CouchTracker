import RxSwift
import TraktSwift

final class ShowDetailsiOSPresenter: ShowDetailsPresenter {
	private weak var view: ShowDetailsView!
	private let router: ShowDetailsRouter
	private let interactor: ShowDetailsInteractor
	private let disposeBag = DisposeBag()

	init(view: ShowDetailsView, router: ShowDetailsRouter, interactor: ShowDetailsInteractor) {
		self.view = view
		self.router = router
		self.interactor = interactor
	}

	func viewDidLoad() {
		interactor.fetchImages().map { ImagesViewModelMapper.viewModel(for: $0) }
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [unowned self] in
				self.view.show(images: $0)
				}, onError: { error in
					print(error.localizedDescription)
			}).disposed(by: disposeBag)

		interactor.fetchDetailsOfShow().map { [unowned self] in self.mapToViewModel($0) }
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [unowned self] viewModel in
				self.view.show(details: viewModel)
				}, onError: { [unowned self] error in
					self.router.showError(message: error.localizedDescription)
			}).disposed(by: disposeBag)
	}

	private func mapToViewModel(_ show: ShowEntity) -> ShowDetailsViewModel {
		let firstAired = show.firstAired?.parse() ?? "Unknown".localized
		let genres = show.genres?.map { $0.name }.joined(separator: " | ")

		return ShowDetailsViewModel(title: show.title ?? "TBA".localized,
																overview: show.overview ?? "",
																network: show.network ?? "Unknown".localized,
																genres: genres ?? "",
																firstAired: firstAired,
																status: show.status?.rawValue.localized ?? "Unknown".localized)
	}
}
