import RxSwift
import TraktSwift

public final class CentralSynchronizer {
  private let disposeBag = DisposeBag()
  private let watchedShowsSynchronizer: WatchedShowsSynchronizer
  private let syncStateOutput: SyncStateOutput

  public static func initialize(watchedShowsSynchronizer: WatchedShowsSynchronizer,
                                appConfigObservable: AppConfigurationsObservable,
                                syncStateOutput: SyncStateOutput) -> CentralSynchronizer {
    return CentralSynchronizer(watchedShowsSynchronizer: watchedShowsSynchronizer,
                               appConfigObservable: appConfigObservable,
                               syncStateOutput: syncStateOutput)
  }

  private init(watchedShowsSynchronizer: WatchedShowsSynchronizer,
               appConfigObservable: AppConfigurationsObservable,
               syncStateOutput: SyncStateOutput) {
    self.watchedShowsSynchronizer = watchedShowsSynchronizer
    self.syncStateOutput = syncStateOutput

    appConfigObservable.observe()
      .filter { $0.loginState != LoginState.notLogged }
      .subscribe(onNext: { [weak self] newAppState in
        self?.handleNew(appState: newAppState)
      }).disposed(by: disposeBag)
  }

  private func handleNew(appState: AppConfigurationsState) {
    let options = CentralSynchronizer.syncOptionsFor(appState: appState)

    syncStateOutput.newSyncState(state: SyncState(watchedShowsSyncState: .syncing))

    watchedShowsSynchronizer.syncWatchedShows(using: options)
      .notifySyncState(syncStateOutput)
      .subscribe().disposed(by: disposeBag)
  }

  private static func syncOptionsFor(appState: AppConfigurationsState) -> WatchedShowEntitiesSyncOptions {
    let defaultOptions = Defaults.showsSyncOptions
    return WatchedShowEntitiesSyncOptions(extended: defaultOptions.extended, hiddingSpecials: appState.hideSpecials)
  }
}
