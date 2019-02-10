import RealmSwift

public final class EpisodeEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingIds: EpisodeIdsRealm?
  @objc public dynamic var showIds: ShowIdsRealm?
  @objc public dynamic var title: String = ""
  @objc public dynamic var overview: String?
  @objc public dynamic var number = -1
  @objc public dynamic var season = -1
  @objc public dynamic var firstAired: Date?

  public var ids: EpisodeIdsRealm? {
    get {
      return backingIds
    }
    set {
      backingIds = newValue
      if let traktId = newValue?.trakt {
        let typeName = String(describing: WatchedShowEntityRealm.self)
        identifier = "\(typeName)-\(traktId)"
      }
    }
  }

  public override static func primaryKey() -> String? {
    return "identifier"
  }

  public override static func ignoredProperties() -> [String] {
    return ["ids"]
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? EpisodeEntityRealm else { return false }

    return self == entity
  }

  public static func == (lhs: EpisodeEntityRealm, rhs: EpisodeEntityRealm) -> Bool {
    return lhs.identifier == rhs.identifier &&
      lhs.backingIds == rhs.backingIds &&
      lhs.showIds == rhs.showIds &&
      lhs.title == rhs.title &&
      lhs.overview == rhs.overview &&
      lhs.number == rhs.number &&
      lhs.season == rhs.season &&
      lhs.firstAired == rhs.firstAired
  }
}
