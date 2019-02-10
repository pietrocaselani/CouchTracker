import RealmSwift
import RxRealm
import RxSwift

public final class RealmShowDataSource {
  private let realmProvider: RealmProvider
  private let scheduler: ImmediateSchedulerType

  public init(realmProvider: RealmProvider, scheduler: ImmediateSchedulerType) {
    self.realmProvider = realmProvider
    self.scheduler = scheduler
  }

  public func observeRealmWatchedShow(showIds: ShowIdsRealm) -> Observable<WatchedShowEntityRealm> {
    let observable = Observable.deferred { [weak self] () -> Observable<WatchedShowEntityRealm> in
      guard let strongSelf = self else {
        return Observable.empty()
      }

      let realm = strongSelf.realmProvider.realm

      let key = WatchedShowEntityRealm.createRealmId(using: showIds.trakt)

      guard let show = realm.object(ofType: WatchedShowEntityRealm.self, forPrimaryKey: key) else {
        return Observable.empty()
      }

      return Observable.from(object: show, emitInitialValue: true)
    }

    return observable.subscribeOn(scheduler)
  }

  public func save(realmShow: WatchedShowEntityRealm) throws {
    let realm = realmProvider.realm

    try realm.write {
      realm.add(realmShow, update: true)
    }
  }
}
