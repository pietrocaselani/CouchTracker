import RxSwift
import RxRealm
import RealmSwift

final class ShowsProgressRealmDataSource: ShowsProgressDataSource {
  private let realmProvider: RealmProvider
  private let schedulers: Schedulers

  init(realmProvider: RealmProvider, schedulers: Schedulers) {
    self.realmProvider = realmProvider
    self.schedulers = schedulers
  }

  func fetchWatchedShows() -> Observable<WatchedShowEntity> {
    let observable = Observable.deferred { [unowned self] () -> Observable<[WatchedShowEntityRealm]> in
      let realm = self.realmProvider.realm
      let results = realm.objects(WatchedShowEntityRealm.self)
      return Observable.array(from: results)
    }

    return observable.flatMap { results -> Observable<WatchedShowEntity> in
      let entities = results.map { $0.toEntity() }
      return Observable.from(entities)
    }
  }

  func addWatched(show: WatchedShowEntity) throws {
    let realm = realmProvider.realm

    try realm.write {
      realm.add(show.toRealm(), update: true)
    }
  }
}
