import RealmSwift
import RxRealm
import RxSwift

public final class RealmShowsDataSource: WatchedShowEntitiesObservable, ShowsDataHolder {
  private let realmProvider: RealmProvider
  private let schedulers: Schedulers

  private struct EntitiesState {
    let entities: [WatchedShowEntity]
    let isSyncing, isLogged: Bool
  }

  public init(realmProvider: RealmProvider, schedulers: Schedulers) {
    self.realmProvider = realmProvider
    self.schedulers = schedulers
  }

  public func observeWatchedShows() -> Observable<[WatchedShowEntity]> {
    return Observable.deferred { [weak self] () -> Observable<[WatchedShowEntityRealm]> in
      guard let strongSelf = self else {
        return Observable.empty()
      }

      let realm = strongSelf.realmProvider.realm
      let results = realm.objects(WatchedShowEntityRealm.self)
      return Observable.array(from: results)
    }.mapElements { $0.toEntity() }
      .subscribeOn(schedulers.dataSourceScheduler)
  }

  public func save(shows: [WatchedShowEntity]) throws {
    let realmEntities = shows.map { $0.toRealm() }

    let realm = realmProvider.realm

    try realm.write {
      realm.add(realmEntities, update: true)
    }
  }
}
