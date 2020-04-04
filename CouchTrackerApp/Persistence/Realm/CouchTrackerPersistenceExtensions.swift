import CouchTrackerCore
import CouchTrackerPersistence
import RealmSwift
import RxSwift
import TraktSwift

extension GenreRealmDataSource: GenreDataSource {
  public func fetchGenres() -> Maybe<[Genre]> {
    fetchRealmGenres().mapElements { $0.toEntity() }
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
    observeRealmWatchedShow(showIds: showIds.toRealm()).map { $0.toEntity() }
  }
}

extension RealmShowsDataSource: WatchedShowEntitiesObservable, ShowsDataHolder {
  public func observeWatchedShows() -> Observable<WatchedShowEntitiesState> {
    observeRealmWatchedShows().map { objectState -> WatchedShowEntitiesState in
      switch objectState {
      case .notInitialized:
        return WatchedShowEntitiesState.unavailable
      case let .available(value):
        return WatchedShowEntitiesState.available(shows: value.map { $0.toEntity() })
      }
    }
  }

  public func save(shows: [WatchedShowEntity]) throws {
    try save(realmShows: shows.map { $0.toRealm() })
  }
}
