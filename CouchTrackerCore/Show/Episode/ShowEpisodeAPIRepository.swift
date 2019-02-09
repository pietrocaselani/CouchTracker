import RxSwift
import TraktSwift

public final class ShowEpisodeAPIRepository: ShowEpisodeRepository {
  private let schedulers: Schedulers
  private let synchronizer: WatchedShowSynchronizer
  private let network: ShowEpisodeNetwork
  private let disposeBag = DisposeBag()
  private var hideSpecials: Bool

  public init(network: ShowEpisodeNetwork,
              schedulers: Schedulers = DefaultSchedulers.instance,
              synchronizer: WatchedShowSynchronizer,
              appConfigurationsObservable: AppStateObservable,
              hideSpecials: Bool) {
    self.network = network
    self.schedulers = schedulers
    self.synchronizer = synchronizer
    self.hideSpecials = hideSpecials

    appConfigurationsObservable.observe().subscribe(onNext: { [unowned self] newState in
      self.hideSpecials = newState.hideSpecials
    }).disposed(by: disposeBag)
  }

  public func addToHistory(episode: EpisodeEntity) -> Single<WatchedShowEntity> {
    let syncEpisode = SyncEpisode(ids: episode.ids)
    let items = SyncItems(episodes: [syncEpisode])
    let single = network.addToHistory(items: items)

    return performSync(single, episode.showIds, episode.season)
  }

  public func removeFromHistory(episode: EpisodeEntity) -> Single<WatchedShowEntity> {
    let syncEpisode = SyncEpisode(ids: episode.ids)
    let items = SyncItems(episodes: [syncEpisode])
    let single = network.removeFromHistory(items: items)

    return performSync(single, episode.showIds, episode.season)
  }

  private func performSync(_ single: Single<SyncResponse>,
                           _ showIds: ShowIds,
                           _ season: Int) -> Single<WatchedShowEntity> {
    return single.flatMap { [weak self] _ -> Single<WatchedShowEntity> in
      guard let strongSelf = self else { return Single.error(CouchTrackerError.selfDeinitialized) }

      let options = WatchedShowEntitySyncOptions(showIds: showIds,
                                                 episodeExtended: .fullEpisodes,
                                                 seasonOptions: .yes(number: season, extended: .fullEpisodes),
                                                 hiddingSpecials: strongSelf.hideSpecials)

      return strongSelf.synchronizer.syncWatchedShow(using: options)
    }
  }
}
