import RealmSwift
import RxRealm
import RxSwift
import TraktSwift

public final class RealmShowDataSource: ShowDataSource {
  private let realmProvider: RealmProvider
  private let schedulers: Schedulers

  public init(realmProvider: RealmProvider, schedulers: Schedulers) {
    self.realmProvider = realmProvider
    self.schedulers = schedulers
  }

  public func observeWatchedShow(showIds: ShowIds) -> Observable<WatchedShowEntity> {
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

    return observable.map { result -> WatchedShowEntity in
      result.toEntity()
    }.subscribeOn(schedulers.dataSourceScheduler)
  }

  public func save(show: WatchedShowEntity) throws {
    let realmEntity = show.toRealm()

    let realm = realmProvider.realm

    try realm.write {
      realm.add(realmEntity, update: true)
    }
  }
}
