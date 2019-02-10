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

  public func observeRealmWatchedShows() -> Observable<[WatchedShowEntityRealm]> {
    return Observable.deferred { [weak self] () -> Observable<[WatchedShowEntityRealm]> in
      guard let strongSelf = self else {
        return Observable.empty()
      }

      let realm = strongSelf.realmProvider.realm
      let results = realm.objects(WatchedShowEntityRealm.self)
      return Observable.array(from: results)
    }.subscribeOn(scheduler)
  }

  public func save(realmShows: [WatchedShowEntityRealm]) throws {
    let realm = realmProvider.realm

    try realm.write {
      realm.add(realmShows, update: true)
    }
  }
}
