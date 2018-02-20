import RxSwift

final class ShowEpisodeiOSPresenter: ShowEpisodePresenter {
	private weak var view: ShowEpisodeView?
	private let interactor: ShowEpisodeInteractor
	private var show: WatchedShowEntity
	private let disposeBag = DisposeBag()

	init(view: ShowEpisodeView, interactor: ShowEpisodeInteractor, show: WatchedShowEntity) {
		self.view = view
		self.interactor = interactor
		self.show = show
	}

	func viewDidLoad() {
		setupView()
	}

	func handleWatch() {
		guard let nextEpisode = show.nextEpisode else { return }

		interactor.toggleWatch(for: nextEpisode, of: show)
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [unowned self] result in
				if case .success(let newShow) = result {
					self.updateShowEntity(using: newShow)
					self.setupView()
				} else if case .fail(let error) = result {
					print(error)
				}
			}).disposed(by: disposeBag)
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

	private func updateShowEntity(using newShow: WatchedShowEntity) {
		let builder = show.newBuilder()
		builder.nextEpisode = newShow.nextEpisode
		builder.aired = newShow.aired
		builder.completed = newShow.completed
		builder.lastWatched = newShow.lastWatched

		self.show = builder.build()
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
