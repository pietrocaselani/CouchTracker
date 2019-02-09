import RxSwift
import TraktSwift

public final class CentralSynchronizer {
  private let disposeBag = DisposeBag()
  private let watchedShowsSynchronizer: WatchedShowsSynchronizer
  private let syncStateOutput: SyncStateOutput

  public static func initialize(watchedShowsSynchronizer: WatchedShowsSynchronizer,
                                appConfigObservable: AppStateObservable,
                                syncStateOutput: SyncStateOutput) -> CentralSynchronizer {
    return CentralSynchronizer(watchedShowsSynchronizer: watchedShowsSynchronizer,
                               appConfigObservable: appConfigObservable,
                               syncStateOutput: syncStateOutput)
  }

  private init(watchedShowsSynchronizer: WatchedShowsSynchronizer,
               appConfigObservable: AppStateObservable,
               syncStateOutput: SyncStateOutput) {
    self.watchedShowsSynchronizer = watchedShowsSynchronizer
    self.syncStateOutput = syncStateOutput

    appConfigObservable.observe()
      .filter { $0.isLogged }
      .subscribe(onNext: { [weak self] newAppState in
        self?.handleNew(appState: newAppState)
      }).disposed(by: disposeBag)
  }

  private func handleNew(appState: AppState) {
    let options = CentralSynchronizer.syncOptionsFor(appState: appState)

    syncStateOutput.newSyncState(state: SyncState(watchedShowsSyncState: .syncing))

    watchedShowsSynchronizer.syncWatchedShows(using: options)
      .notifySyncState(syncStateOutput)
      .subscribe()
      .disposed(by: disposeBag)
  }

  private static func syncOptionsFor(appState: AppState) -> WatchedShowEntitiesSyncOptions {
    let defaultOptions = Defaults.showsSyncOptions
    return WatchedShowEntitiesSyncOptions(extended: defaultOptions.extended, hiddingSpecials: appState.hideSpecials)
  }
}
