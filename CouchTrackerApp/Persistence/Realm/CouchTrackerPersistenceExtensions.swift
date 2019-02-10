import CouchTrackerCore
import CouchTrackerPersistence
import RealmSwift
import RxSwift
import TraktSwift

extension GenreRealmDataSource: GenreDataSource {
  public func fetchGenres() -> Maybe<[Genre]> {
    return fetchRealmGenres().mapElements { $0.toEntity() }
  }

  public func save(genres: [Genre]) throws {
    let realmEntities = genres.map { $0.toRealm() }
    try save(realmGenres: realmEntities)
  }
}

extension RealmShowDataSource: ShowDataSource {
  public func save(show: WatchedShowEntity) throws {
    try save(realmShow: show.toRealm())
  }

  public func observeWatchedShow(showIds: ShowIds) -> Observable<WatchedShowEntity> {
    return observeRealmWatchedShow(showIds: showIds.toRealm()).map { $0.toEntity() }
  }
}

extension RealmShowsDataSource: WatchedShowEntitiesObservable, ShowsDataHolder {
  public func observeWatchedShows() -> Observable<[WatchedShowEntity]> {
    return observeRealmWatchedShows().mapElements { $0.toEntity() }
  }

  public func save(shows: [WatchedShowEntity]) throws {
    try save(realmShows: shows.map { $0.toRealm() })
  }
}
