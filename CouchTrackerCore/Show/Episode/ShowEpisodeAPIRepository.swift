import RxSwift
import TraktSwift

public final class ShowEpisodeAPIRepository: ShowEpisodeRepository {
  private let schedulers: Schedulers
  private let dataSource: ShowEpisodeDataSource
  private let synchronizer: WatchedShowSynchronizer
  private let network: ShowEpisodeNetwork
  private let disposeBag = DisposeBag()
  private var hideSpecials: Bool

  public init(dataSource: ShowEpisodeDataSource, network: ShowEpisodeNetwork,
              schedulers: Schedulers, synchronizer: WatchedShowSynchronizer,
              appConfigurationsObservable: AppConfigurationsObservable, hideSpecials: Bool) {
    self.dataSource = dataSource
    self.network = network
    self.schedulers = schedulers
    self.synchronizer = synchronizer
    self.hideSpecials = hideSpecials

    appConfigurationsObservable.observe().subscribe(onNext: { [unowned self] newState in
      self.hideSpecials = newState.hideSpecials
    }).disposed(by: disposeBag)
  }

  public func addToHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<WatchedShowEntity> {
    let syncEpisode = SyncEpisode(ids: episode.ids)
    let items = SyncItems(episodes: [syncEpisode])
    let single = network.addToHistory(items: items)

    return performSync(single, show.show, episode.season)
  }

  public func removeFromHistory(of show: WatchedShowEntity, episode: EpisodeEntity) -> Single<WatchedShowEntity> {
    let syncEpisode = SyncEpisode(ids: episode.ids)
    let items = SyncItems(episodes: [syncEpisode])
    let single = network.removeFromHistory(items: items)

    return performSync(single, show.show, episode.season)
  }

  private func performSync(_ single: Single<SyncResponse>,
                           _ show: ShowEntity,
                           _ season: Int) -> Single<WatchedShowEntity> {
    return single.flatMap { [weak self] _ -> Single<WatchedShowEntity> in
      guard let strongSelf = self else { return Single.error(CouchTrackerError.selfDeinitialized) }

      let options = WatchedShowEntitySyncOptions(showIds: show.ids,
                                                 episodeExtended: .fullEpisodes,
                                                 seasonOptions: .yes(number: season, extended: .fullEpisodes),
                                                 hiddingSpecials: strongSelf.hideSpecials)

      return strongSelf.synchronizer.syncWatchedShow(using: options)
    }
  }
}
