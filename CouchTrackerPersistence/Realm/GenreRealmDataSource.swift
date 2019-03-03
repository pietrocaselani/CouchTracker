import Realm
import RxSwift

public final class GenreRealmDataSource {
  private let realmProvider: RealmProvider
  private let scheduler: ImmediateSchedulerType

  public init(realmProvider: RealmProvider, scheduler: ImmediateSchedulerType) {
    self.realmProvider = realmProvider
    self.scheduler = scheduler
  }

  public func fetchRealmGenres() -> Maybe<[GenreRealm]> {
    let maybe = Maybe.deferred { [weak self] () -> Maybe<[GenreRealm]> in
      guard let strongSelf = self else { return Maybe.empty() }

      let realm = strongSelf.realmProvider.realm
      let genres = realm.objects(GenreRealm.self).toArray()

      return genres.isEmpty ? Maybe.empty() : Maybe.just(genres)
    }

    return maybe.subscribeOn(scheduler)
  }

  public func save(realmGenres: [GenreRealm]) throws {
    let realm = realmProvider.realm
    try realm.initializeAndAdd(realmGenres, update: true)
  }
}
