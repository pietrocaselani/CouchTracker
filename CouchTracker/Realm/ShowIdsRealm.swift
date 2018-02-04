import RealmSwift
import TraktSwift

final class ShowIdsRealm: Object {
  @objc dynamic var trakt = -1
  let tmdb = RealmOptional<Int>()
  @objc dynamic var imdb: String?
  @objc dynamic var slug = ""
  @objc dynamic var tvdb = -1
  let tvrage = RealmOptional<Int>()

  override static func primaryKey() -> String? {
    return "trakt"
  }

  func toEntity() -> ShowIds {
    return ShowIds(trakt: self.trakt,
                   tmdb: self.tmdb.value,
                   imdb: self.imdb,
                   slug: self.slug,
                   tvdb: self.tvdb,
                   tvrage: self.tvrage.value)
  }
}

extension ShowIds {
  func toRealm() -> ShowIdsRealm {
    let entity = ShowIdsRealm()

    entity.trakt = self.trakt
    entity.tmdb.value = self.tmdb
    entity.imdb = self.imdb
    entity.slug = self.slug
    entity.tvdb = self.tvdb
    entity.tvrage.value = self.tvrage

    return entity
  }
}
