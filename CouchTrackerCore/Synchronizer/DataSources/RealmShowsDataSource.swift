import RealmSwift
import RxRealm
import RxSwift

public final class RealmShowsDataSource: WatchedShowEntitiesObservable, ShowsDataHolder {
  private let realmProvider: RealmProvider
  private let schedulers: Schedulers
  private let syncObservable: SyncStateObservable

  public init(realmProvider: RealmProvider, syncObservable: SyncStateObservable, schedulers: Schedulers) {
    self.realmProvider = realmProvider
    self.syncObservable = syncObservable
    self.schedulers = schedulers
  }

  public func observeWatchedShows() -> Observable<[WatchedShowEntity]> {
    let observable = Observable.deferred { [weak self] () -> Observable<[WatchedShowEntityRealm]> in
      guard let strongSelf = self else {
        return Observable.empty()
      }

      let realm = strongSelf.realmProvider.realm
      let results = realm.objects(WatchedShowEntityRealm.self)
      return Observable.array(from: results)
    }

    let realmObservable = observable.map { results -> [WatchedShowEntity] in
      results.map { $0.toEntity() }
    }.subscribeOn(schedulers.dataSourceScheduler)

    return Observable.combineLatest(syncObservable.observe(), realmObservable) { syncState, entities in
      print("ViewState realm is sync = \(syncState.isSyncing)")

      return entities
    }
  }

  public func save(shows: [WatchedShowEntity]) throws {
    let realmEntities = shows.map { $0.toRealm() }

    let realm = realmProvider.realm

    try realm.write {
      realm.add(realmEntities, update: true)
    }
  }
}
