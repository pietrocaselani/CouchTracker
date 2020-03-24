import RxSwift

#if DEBUG
public var Current = SyncEnvironment.live
#else
public let Current = SyncEnvironment.live
#endif

var trakt: Trakt!
var scheduler: ImmediateSchedulerType!

public func setupSyncModule(trakt: Trakt, schedulers: SyncSchedulers = .live) -> (SyncOptions) -> Observable<Show> {
  CouchTrackerSync.trakt = trakt
  CouchTrackerSync.scheduler = schedulers.syncScheduler
  return { options in
    startSync(options)
  }
}
