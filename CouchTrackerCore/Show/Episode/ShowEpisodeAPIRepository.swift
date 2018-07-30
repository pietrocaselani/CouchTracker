import RxSwift
import TraktSwift

public final class ShowEpisodeAPIRepository: ShowEpisodeRepository {
    private let schedulers: Schedulers
    private let dataSource: ShowEpisodeDataSource
    private let network: ShowEpisodeNetwork
    private let showProgressRepository: ShowProgressRepository
    private let disposeBag = DisposeBag()
    private var hideSpecials: Bool

    public init(dataSource: ShowEpisodeDataSource, network: ShowEpisodeNetwork,
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

    public func addToHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult> {
        let syncEpisode = SyncEpisode(ids: episode.ids)
        let items = SyncItems(episodes: [syncEpisode])
        let single = network.addToHistory(items: items)

        return performSync(single, show.show)
    }

    public func removeFromHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<SyncResult> {
        let syncEpisode = SyncEpisode(ids: episode.ids)
        let items = SyncItems(episodes: [syncEpisode])
        let single = network.removeFromHistory(items: items)

        return performSync(single, show.show)
    }

    private func performSync(_ single: Single<SyncResponse>, _ show: ShowEntity) -> Single<SyncResult> {
        return single.flatMap { [unowned self] _ -> Single<WatchedShowEntity> in
            self.showProgressRepository.fetchShowProgress(ids: show.ids, hideSpecials: self.hideSpecials)
                .map { $0.createEntity(using: show) }
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
