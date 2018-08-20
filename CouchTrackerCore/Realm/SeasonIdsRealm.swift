import RealmSwift
import TraktSwift

public final class SeasonIdsRealm: Object {
  @objc public dynamic var trakt = -1
  public let tmdb = RealmOptional<Int>()
  public let tvdb = RealmOptional<Int>()
  public let tvrage = RealmOptional<Int>()

  public override static func primaryKey() -> String? {
    return "trakt"
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? EpisodeIdsRealm else { return false }

    return self == entity
  }

  public static func == (lhs: SeasonIdsRealm, rhs: SeasonIdsRealm) -> Bool {
    return lhs.trakt == rhs.trakt &&
      lhs.tmdb.value == rhs.tmdb.value &&
      lhs.tvdb.value == rhs.tvdb.value &&
      lhs.tvrage.value == rhs.tvrage.value
  }

  public func toEntity() -> SeasonIds {
    return SeasonIds(tvdb: tvdb.value, tmdb: tmdb.value, trakt: trakt, tvrage: tvrage.value)
  }
}

extension SeasonIds {
  public func toRealm() -> SeasonIdsRealm {
    let entity = SeasonIdsRealm()

    entity.trakt = trakt
    entity.tmdb.value = tmdb
    entity.tvdb.value = tvdb
    entity.tvrage.value = tvrage

    return entity
  }
}
