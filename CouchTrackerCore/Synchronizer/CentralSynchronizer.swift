import RxSwift
import TraktSwift

public final class CentralSynchronizer {
  private let disposeBag = DisposeBag()
  private let syncStateSubject: BehaviorSubject<SyncState>
  private let watchedShowsSynchronizer: WatchedShowsSynchronizer
  private let watchedShowSynchronizer: WatchedShowSynchronizer

  public init(watchedShowsSynchronizer: WatchedShowsSynchronizer,
              watchedShowSynchronizer: WatchedShowSynchronizer,
              appStateObservable: AppStateObservable) {
    self.watchedShowsSynchronizer = watchedShowsSynchronizer
    self.watchedShowSynchronizer = watchedShowSynchronizer
    syncStateSubject = BehaviorSubject<SyncState>(value: .initial)

    appStateObservable.observe()
      .filter { $0.isLogged }
      .subscribe(onNext: { [weak self] newAppState in
        self?.handleNew(appState: newAppState)
      }).disposed(by: disposeBag)
  }

  private func handleNew(appState: AppState) {
    let options = CentralSynchronizer.syncOptionsFor(appState: appState)

    syncWatchedShows(using: options).subscribe().disposed(by: disposeBag)
  }

  private static func syncOptionsFor(appState: AppState) -> WatchedShowEntitiesSyncOptions {
    let defaultOptions = Defaults.showsSyncOptions
    return WatchedShowEntitiesSyncOptions(extended: defaultOptions.extended, hiddingSpecials: appState.hideSpecials, seasonExtended: [.full, .episodes])
  }
}

extension CentralSynchronizer: WatchedShowsSynchronizer {
  public func syncWatchedShows(using options: WatchedShowEntitiesSyncOptions) -> Single<[WatchedShowEntity]> {
    syncStateSubject.onNext(SyncState(watchedShowsSyncState: .syncing))

    return watchedShowsSynchronizer.syncWatchedShows(using: options)
      .do(onDispose: { [weak self] in
        self?.syncStateSubject.onNext(SyncState(watchedShowsSyncState: .notSyncing))
      })
  }
}

extension CentralSynchronizer: WatchedShowSynchronizer {
  public func syncWatchedShow(using options: WatchedShowEntitySyncOptions) -> Single<WatchedShowEntity> {
    syncStateSubject.onNext(SyncState(watchedShowsSyncState: .syncing))

    return watchedShowSynchronizer.syncWatchedShow(using: options)
      .do(onDispose: { [weak self] in
        self?.syncStateSubject.onNext(SyncState(watchedShowsSyncState: .notSyncing))
      })
  }
}

extension CentralSynchronizer: SyncStateObservable {
  public func observe() -> Observable<SyncState> {
    return syncStateSubject.distinctUntilChanged()
  }
}
