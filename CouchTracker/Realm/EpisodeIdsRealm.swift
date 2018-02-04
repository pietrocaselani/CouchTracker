import RealmSwift
import TraktSwift

final class EpisodeIdsRealm: Object {
  @objc dynamic var trakt = -1
  let tmdb = RealmOptional<Int>()
  @objc dynamic var imdb: String?
  @objc dynamic var tvdb = -1
  let tvrage = RealmOptional<Int>()

  override static func primaryKey() -> String? {
    return "trakt"
  }

  func toEntity() -> EpisodeIds {
    return EpisodeIds(trakt: self.trakt,
                      tmdb: self.tmdb.value,
                      imdb: self.imdb,
                      tvdb: self.tvdb,
                      tvrage: self.tvrage.value)
  }
}

extension EpisodeIds {
  func toRealm() -> EpisodeIdsRealm {
    let entity = EpisodeIdsRealm()

    entity.trakt = self.trakt
    entity.tmdb.value = self.tmdb
    entity.imdb = self.imdb
    entity.tvdb = self.tvdb
    entity.tvrage.value = self.tvrage

    return entity
  }
}
