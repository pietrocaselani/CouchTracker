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

  override var hashValue: Int {
    var hash = super.hashValue

    hash ^= trakt.hashValue

    tmdb.value.run { hash ^= $0.hashValue }

    imdb.run { hash ^= $0.hashValue }

    hash ^= tvdb.hashValue

    tvrage.value.run { hash ^= $0.hashValue }

    return hash
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
