import RealmSwift
import RxRealm
import RxSwift

public final class RealmShowsDataSource {
  private let realmProvider: RealmProvider
  private let scheduler: ImmediateSchedulerType

  public init(realmProvider: RealmProvider, scheduler: ImmediateSchedulerType) {
    self.realmProvider = realmProvider
    self.scheduler = scheduler
  }

  public func observeRealmWatchedShows() -> Observable<RealmObjectState<[WatchedShowEntityRealm]>> {
    Observable.deferred { [weak self] () -> Observable<RealmObjectState<[WatchedShowEntityRealm]>> in
      guard let strongSelf = self else {
        return Observable.empty()
      }

      let realm = strongSelf.realmProvider.realm

      return realm.observeArray(of: WatchedShowEntityRealm.self)
    }.subscribeOn(scheduler)
  }

  public func save(realmShows: [WatchedShowEntityRealm]) throws {
    let realm = realmProvider.realm
    try realm.initializeAndAdd(realmShows, update: true)
  }
}
