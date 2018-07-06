import RxSwift
import TraktSwift

public final class ShowOverviewDefaultPresenter: ShowOverviewPresenter {
	private weak var view: ShowOverviewView!
	private let router: ShowOverviewRouter
	private let interactor: ShowOverviewInteractor
	private let disposeBag = DisposeBag()

	public init(view: ShowOverviewView, router: ShowOverviewRouter, interactor: ShowOverviewInteractor) {
		self.view = view
		self.router = router
		self.interactor = interactor
	}

	public func viewDidLoad() {
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

	private func mapToViewModel(_ show: ShowEntity) -> ShowOverviewViewModel {
		let firstAired = show.firstAired?.parse() ?? "Unknown".localized
		let genres = show.genres?.map { $0.name }.joined(separator: " | ")

		return ShowOverviewViewModel(title: show.title ?? "TBA".localized,
																overview: show.overview ?? "",
																network: show.network ?? "Unknown".localized,
																genres: genres ?? "",
																firstAired: firstAired,
																status: show.status?.rawValue.localized ?? "Unknown".localized)
	}
}
