import RealmSwift

public final class ShowIdsRealm: Object {
  @objc public dynamic var trakt = -1
  public let tmdb = RealmOptional<Int>()
  @objc public dynamic var imdb: String?
  @objc public dynamic var slug = ""
  @objc public dynamic var tvdb = -1
  public let tvrage = RealmOptional<Int>()

  public override static func primaryKey() -> String? {
    "trakt"
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? ShowIdsRealm else { return false }

    return self == entity
  }

  public static func == (lhs: ShowIdsRealm, rhs: ShowIdsRealm) -> Bool {
    lhs.trakt == rhs.trakt &&
      lhs.tmdb.value == rhs.tmdb.value &&
      lhs.imdb == rhs.imdb &&
      lhs.slug == rhs.slug &&
      lhs.tvdb == rhs.tvdb &&
      lhs.tvrage.value == rhs.tvrage.value
  }
}
