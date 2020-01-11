import RxSwift
import RealmSwift

func allWatchedShows() -> Single<RealmObjectState<[ShowRealm]>> {
  return Single.deferred {
    realmProvider.realm.observeArray(of: ShowRealm.self).take(1).asSingle()
  }.subscribeOn(scheduler)
}

func saveShows(shows: [ShowRealm]) -> Completable {
  return Completable.deferred {
    Completable.create { completable -> Disposable in
      do {
        try realmProvider.realm.initializeAndAdd(shows, update: true)
        completable(.completed)
      } catch {
        completable(.error(error))
      }

      return Disposables.create()
    }
  }.subscribeOn(scheduler)
}
