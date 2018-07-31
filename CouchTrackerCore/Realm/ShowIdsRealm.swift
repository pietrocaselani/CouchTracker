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

  override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? ShowIdsRealm else { return false }

    return self == entity
  }

  static func == (lhs: ShowIdsRealm, rhs: ShowIdsRealm) -> Bool {
    return lhs.trakt == rhs.trakt &&
      lhs.tmdb.value == rhs.tmdb.value &&
      lhs.imdb == rhs.imdb &&
      lhs.slug == rhs.slug &&
      lhs.tvdb == rhs.tvdb &&
      lhs.tvrage.value == rhs.tvrage.value
  }

  func toEntity() -> ShowIds {
    return ShowIds(trakt: trakt,
                   tmdb: tmdb.value,
                   imdb: imdb,
                   slug: slug,
                   tvdb: tvdb,
                   tvrage: tvrage.value)
  }
}

extension ShowIds {
  func toRealm() -> ShowIdsRealm {
    let entity = ShowIdsRealm()

    entity.trakt = trakt
    entity.tmdb.value = tmdb
    entity.imdb = imdb
    entity.slug = slug
    entity.tvdb = tvdb
    entity.tvrage.value = tvrage

    return entity
  }
}
