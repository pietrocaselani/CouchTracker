import RealmSwift

public final class ShowRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingIds: ShowIdsRealm?
  @objc public dynamic var title: String?
  @objc public dynamic var overview: String?
  @objc public dynamic var network: String?
  public let genres = List<GenreRealm>()
  @objc public dynamic var status: String?
  @objc public dynamic var firstAired: Date?
  public let seasons = List<WatchedSeasonRealm>()
  public let aired = RealmOptional<Int>()
  public let completed = RealmOptional<Int>()
  @objc public dynamic var nextEpisode: WatchedEpisodeRealm?
  @objc public dynamic var lastEpisode: WatchedEpisodeRealm?

  public var ids: ShowIdsRealm? {
    get { backingIds }
    set {
      backingIds = newValue
      if let traktId = newValue?.trakt {
        let typeName = String(describing: ShowRealm.self)
        identifier = "\(typeName)-\(traktId)"
      }
    }
  }

  public override static func primaryKey() -> String? {
    "identifier"
  }

  public override static func ignoredProperties() -> [String] {
    ["ids"]
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? ShowRealm else { return false }
    return self == entity
  }

  public static func == (lhs: ShowRealm, rhs: ShowRealm) -> Bool {
    lhs.identifier == rhs.identifier &&
      lhs.backingIds == rhs.backingIds &&
      lhs.title == rhs.title &&
      lhs.overview == rhs.overview &&
      lhs.network == rhs.network &&
      lhs.genres == rhs.genres &&
      lhs.status == rhs.status &&
      lhs.firstAired == rhs.firstAired &&
      lhs.seasons == rhs.seasons &&
      lhs.aired.value == rhs.aired.value &&
      lhs.nextEpisode == rhs.nextEpisode &&
      lhs.completed.value == rhs.completed.value &&
      lhs.lastEpisode == rhs.lastEpisode
  }
}
