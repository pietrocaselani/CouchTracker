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
    let realmObservable = realmProvider.asSingle().asObservable()

    let resultsObservable = realmObservable.flatMap { realm -> Observable<Results<WatchedShowEntityRealm>> in
      let results = realm.objects(WatchedShowEntityRealm.self)

      guard !results.isEmpty else { return Observable.empty() }

      return Observable.collection(from: results)
    }

    let entitiesObservable = resultsObservable.flatMap { results -> Observable<WatchedShowEntity> in
      let entities = results.map { $0.toEntity() }
      return Observable.from(entities)
    }

    return entitiesObservable
  }

  func addWatched(show: WatchedShowEntity) throws {
    let realm = realmProvider.realm

    try realm.write {
      realm.add(show.toRealm(), update: true)
    }
  }
}
