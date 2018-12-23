import Realm
import RxSwift
import TraktSwift

public final class GenreRealmDataSource: GenreDataSource {
  private let realmProvider: RealmProvider
  private let schedulers: Schedulers

  public init(realmProvider: RealmProvider, schedulers: Schedulers) {
    self.realmProvider = realmProvider
    self.schedulers = schedulers
  }

  public func fetchGenres() -> Maybe<[Genre]> {
    let maybe = Maybe.deferred { [weak self] () -> Maybe<[GenreRealm]> in
      guard let strongSelf = self else { return Maybe.empty() }

      let realm = strongSelf.realmProvider.realm
      let genres = realm.objects(GenreRealm.self).toArray()

      return genres.isEmpty ? Maybe.empty() : Maybe.just(genres)
    }

    return maybe.map { $0.map { $0.toEntity() } }.subscribeOn(schedulers.dataSourceScheduler)
  }

  public func save(genres: [Genre]) throws {
    let realmEntities = genres.map { $0.toRealm() }

    let realm = realmProvider.realm

    try realm.write {
      realm.add(realmEntities, update: true)
    }
  }
}
