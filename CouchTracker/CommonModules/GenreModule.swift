import CouchTrackerCore

final class GenreModule {
  private init() {}

  static func setupGenreDataSource() -> GenreDataSource {
    let realm = Environment.instance.realmProvider
    let schedulers = Environment.instance.schedulers
    return GenreRealmDataSource(realmProvider: realm, schedulers: schedulers)
  }

  static func setupGenreRepository() -> GenreRepository {
    let schedulers = Environment.instance.schedulers
    let trakt = Environment.instance.trakt
    let dataSource = GenreModule.setupGenreDataSource()
    return TraktGenreRepository(traktProvider: trakt, dataSource: dataSource, schedulers: schedulers)
  }
}
