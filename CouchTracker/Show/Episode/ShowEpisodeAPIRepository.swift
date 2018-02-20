import TraktSwift
import RxSwift

final class ShowEpisodeAPIRepository: ShowEpisodeRepository {
	private let schedulers: Schedulers
	private let dataSource: ShowEpisodeDataSource
	private let network: ShowEpisodeNetwork
	private let showProgressRepository: ShowProgressRepository
	private let disposeBag = DisposeBag()
	private var hideSpecials: Bool

	init(dataSource: ShowEpisodeDataSource, network: ShowEpisodeNetwork,
						schedulers: Schedulers, showProgressRepository: ShowProgressRepository,
						appConfigurationsObservable: AppConfigurationsObservable, hideSpecials: Bool) {
		self.dataSource = dataSource
		self.network = network
		self.schedulers = schedulers
		self.showProgressRepository = showProgressRepository
		self.hideSpecials = hideSpecials

		appConfigurationsObservable.observe().subscribe(onNext: { [unowned self] newState in
			self.hideSpecials = newState.hideSpecials
		}).disposed(by: disposeBag)
	}

	func addToHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult> {
		let syncEpisode = SyncEpisode(ids: episode.ids)
		let items = SyncItems(episodes: [syncEpisode])
		let showEntity = show.show
		let showIds = showEntity.ids

		return network.addToHistory(items: items)
			.flatMap { [unowned self] _ -> Single<WatchedShowEntity> in
				return self.showProgressRepository.fetchShowProgress(ids: showIds, hideSpecials: self.hideSpecials)
					.map { $0.createEntity(using: showEntity) }
			}.observeOn(schedulers.dataSourceScheduler)
			.do(onSuccess: { [unowned self] newWatchedShowEntity in
				try self.dataSource.updateWatched(show: newWatchedShowEntity)
			}).map { newWatchedShowEntity -> SyncResult in
				SyncResult.success(show: newWatchedShowEntity)
			}.catchError { error -> Single<SyncResult> in
				Single.just(SyncResult.fail(error: error))
		}
	}

	func removeFromHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult> {
		let syncEpisode = SyncEpisode(ids: episode.ids)
		let items = SyncItems(episodes: [syncEpisode])
		let showEntity = show.show
		let showIds = showEntity.ids

		return network.removeFromHistory(items: items)
			.flatMap { [unowned self] _ -> Single<WatchedShowEntity> in
				return self.showProgressRepository.fetchShowProgress(ids: showIds, hideSpecials: self.hideSpecials)
					.map { $0.createEntity(using: showEntity) }
			}.observeOn(schedulers.dataSourceScheduler)
			.do(onSuccess: { [unowned self] newWatchedShowEntity in
				try self.dataSource.updateWatched(show: newWatchedShowEntity)
			}).map { newWatchedShowEntity -> SyncResult in
				SyncResult.success(show: newWatchedShowEntity)
			}.catchError { error -> Single<SyncResult> in
				Single.just(SyncResult.fail(error: error))
		}
	}
}
