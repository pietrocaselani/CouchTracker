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

	func fetchWatchedShows() -> Observable<[WatchedShowEntity]> {
		let observable = Observable.deferred { [unowned self] () -> Observable<[WatchedShowEntityRealm]> in
			let realm = self.realmProvider.realm
			let results = realm.objects(WatchedShowEntityRealm.self)
			return Observable.array(from: results)
		}

		return observable.map { results -> [WatchedShowEntity] in
			return results.map { $0.toEntity() }
		}.subscribeOn(schedulers.dataSourceScheduler)
	}

	func addWatched(shows: [WatchedShowEntity]) throws {
		let realmEntities = shows.map { $0.toRealm() }

		let realm = realmProvider.realm

		try realm.write {
			realm.add(realmEntities, update: true)
		}
	}
}
