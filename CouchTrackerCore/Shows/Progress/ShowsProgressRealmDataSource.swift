import RealmSwift
import RxRealm
import RxSwift

public final class ShowsProgressRealmDataSource: ShowsProgressDataSource {
    private let realmProvider: RealmProvider
    private let schedulers: Schedulers

    public init(realmProvider: RealmProvider, schedulers: Schedulers) {
        self.realmProvider = realmProvider
        self.schedulers = schedulers
    }

    public func fetchWatchedShows() -> Observable<[WatchedShowEntity]> {
        let observable = Observable.deferred { [weak self] () -> Observable<[WatchedShowEntityRealm]> in
            guard let strongSelf = self else {
                return Observable.empty()
            }

            let realm = strongSelf.realmProvider.realm
            let results = realm.objects(WatchedShowEntityRealm.self)
            return Observable.array(from: results)
        }

        return observable.map { results -> [WatchedShowEntity] in
            results.map { $0.toEntity() }
        }.subscribeOn(schedulers.dataSourceScheduler)
    }

    public func addWatched(shows: [WatchedShowEntity]) throws {
        let realmEntities = shows.map { $0.toRealm() }

        let realm = realmProvider.realm

        try realm.write {
            realm.add(realmEntities, update: true)
        }
    }
}
