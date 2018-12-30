import RxSwift
import TraktSwift

// TODO: Add sync state

public final class CentralSynchronizer {
  private let disposeBag = DisposeBag()
  private let watchedShowsSynchronizer: WatchedShowsSynchronizer

  public static func initialize(watchedShowsSynchronizer: WatchedShowsSynchronizer,
                                appConfigObservable: AppConfigurationsObservable) -> CentralSynchronizer {
    return CentralSynchronizer(watchedShowsSynchronizer: watchedShowsSynchronizer,
                               appConfigObservable: appConfigObservable)
  }

  private init(watchedShowsSynchronizer: WatchedShowsSynchronizer,
               appConfigObservable: AppConfigurationsObservable) {
    self.watchedShowsSynchronizer = watchedShowsSynchronizer

    appConfigObservable.observe().distinctUntilChanged().subscribe(onNext: { [weak self] newAppState in
      self?.handleNew(appState: newAppState)
    }).disposed(by: disposeBag)
  }

  private func handleNew(appState: AppConfigurationsState) {
    let options = CentralSynchronizer.syncOptionsFor(appState: appState)

    watchedShowsSynchronizer.syncWatchedShows(using: options).subscribe().disposed(by: disposeBag)
  }

  private static func syncOptionsFor(appState: AppConfigurationsState) -> WatchedShowEntitiesSyncOptions {
    let defaultOptions = Defaults.showsSyncOptions
    return WatchedShowEntitiesSyncOptions(extended: defaultOptions.extended, hiddingSpecials: appState.hideSpecials)
  }
}
