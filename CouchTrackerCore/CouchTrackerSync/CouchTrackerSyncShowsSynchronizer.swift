import CouchTrackerSync
import RxSwift

public final class CouchTrackerSyncShowsSynchronizer: WatchedShowsSynchronizer {
  private let startSync: (SyncOptions) -> Observable<CouchTrackerSync.Show>
  private let appStateObservable: AppStateObservable
  private let showsDataHolder: ShowsDataHolder
  private let schedulers: Schedulers

  public init(trakt: Trakt, appStateObservable: AppStateObservable,
              showsDataHolder: ShowsDataHolder, schedulers: Schedulers = DefaultSchedulers.instance) {
    self.startSync = setupSyncModule(trakt: trakt)
    self.appStateObservable = appStateObservable
    self.showsDataHolder = showsDataHolder
    self.schedulers = schedulers
  }

  public func syncWatchedShows(using options: WatchedShowEntitiesSyncOptions) -> Single<[WatchedShowEntity]> {
    return appStateObservable.observe()
      .observeOn(schedulers.networkScheduler)
      .map(mapAppStateToSyncOptions(appState:))
      .flatMap(startSync)
      .map(mapShowToWatchedShowEntity(show:))
      .observeOn(schedulers.dataSourceScheduler)
      .do(onNext: { [showsDataHolder] show in
        try showsDataHolder.save(show: show)
      })
      .toArray()
      .do(onError: { error in
        print(">>> Error! \(error)")
      })
      .debug(">>> [Sync]", trimOutput: true)

  }
}

private func mapAppStateToSyncOptions(appState: AppState) -> SyncOptions {
  return SyncOptions(watchedProgress: mapAppStateToWatchedProgressOptions(appState: appState))
}

private func mapAppStateToWatchedProgressOptions(appState: AppState) -> WatchedProgressOptions {
  return WatchedProgressOptions(hidden: !appState.hideSpecials, specials: !appState.hideSpecials, countSpecials: !appState.hideSpecials)
}
