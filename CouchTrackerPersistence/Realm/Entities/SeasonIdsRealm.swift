import RealmSwift

public final class SeasonIdsRealm: Object {
  @objc public dynamic var trakt = -1
  public let tmdb = RealmOptional<Int>()
  public let tvdb = RealmOptional<Int>()
  public let tvrage = RealmOptional<Int>()

  public override static func primaryKey() -> String? {
    "trakt"
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? EpisodeIdsRealm else { return false }

    return self == entity
  }

  public static func == (lhs: SeasonIdsRealm, rhs: SeasonIdsRealm) -> Bool {
    lhs.trakt == rhs.trakt &&
      lhs.tmdb.value == rhs.tmdb.value &&
      lhs.tvdb.value == rhs.tvdb.value &&
      lhs.tvrage.value == rhs.tvrage.value
  }
}
