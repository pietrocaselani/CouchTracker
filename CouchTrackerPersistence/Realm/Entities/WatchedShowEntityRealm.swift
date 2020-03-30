import RealmSwift

public final class WatchedShowEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingShow: ShowEntityRealm?
  @objc public dynamic var nextEpisode: WatchedEpisodeEntityRealm?
  @objc public dynamic var lastWatched: Date?
  public let aired = RealmOptional<Int>()
  public let completed = RealmOptional<Int>()
  public let seasons = List<WatchedSeasonEntityRealm>()

  public var show: ShowEntityRealm? {
    get {
      backingShow
    }
    set {
      backingShow = newValue
      if let traktId = newValue?.ids?.trakt {
        identifier = WatchedShowEntityRealm.createRealmId(using: traktId)
      }
    }
  }

  public static func createRealmId(using traktId: Int) -> String {
    let typeName = String(describing: WatchedShowEntityRealm.self)
    return "\(typeName)-\(traktId)"
  }

  public override static func primaryKey() -> String? {
    "identifier"
  }

  public override static func ignoredProperties() -> [String] {
    ["show"]
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? WatchedShowEntityRealm else { return false }

    return self == entity
  }

  public static func == (lhs: WatchedShowEntityRealm, rhs: WatchedShowEntityRealm) -> Bool {
    lhs.identifier == rhs.identifier &&
      lhs.backingShow == rhs.backingShow &&
      lhs.aired.value == rhs.aired.value &&
      lhs.completed.value == rhs.completed.value &&
      lhs.nextEpisode == rhs.nextEpisode &&
      lhs.lastWatched == rhs.lastWatched
  }
}
