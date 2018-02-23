import RxSwift

public final class ShowEpisodeDefaultPresenter: ShowEpisodePresenter {
	private weak var view: ShowEpisodeView?
	private let interactor: ShowEpisodeInteractor
	private let router: ShowEpisodeRouter
	private var show: WatchedShowEntity
	private let disposeBag = DisposeBag()

	public init(view: ShowEpisodeView, interactor: ShowEpisodeInteractor,
													router: ShowEpisodeRouter, show: WatchedShowEntity) {
		self.view = view
		self.interactor = interactor
		self.router = router
		self.show = show
	}

	public func viewDidLoad() {
		setupView()
	}

	public func handleWatch() {
		guard let nextEpisode = show.nextEpisode else { return }

		interactor.toggleWatch(for: nextEpisode, of: show)
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [unowned self] result in
				if case .success(let newShow) = result {
					self.show = newShow
					self.setupView()
				} else if case .fail(let error) = result {
					self.router.showError(message: error.localizedDescription)
				}
			}) { [unowned self] error in
				self.router.showError(message: error.localizedDescription)
		}.disposed(by: disposeBag)
	}

	private func setupView() {
		guard let view = view else { return }

		guard let nextEpisode = show.nextEpisode else {
			view.showEmptyView()
			return
		}

		interactor.fetchImageURL(for: nextEpisode)
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [unowned self] url in
				self.view?.showEpisodeImage(with: url)
			}).disposed(by: disposeBag)

		view.show(viewModel: mapToViewModel(nextEpisode))
	}

	private func mapToViewModel(_ episode: EpisodeEntity) -> ShowEpisodeViewModel {
		let number = "Season \(episode.season) Episode \(episode.number)"
		let date = episode.firstAired?.shortString() ?? "Unknown".localized

		return ShowEpisodeViewModel(title: episode.title,
																number: number,
																date: date,
																watched: episode.lastWatched != nil)
	}
}
