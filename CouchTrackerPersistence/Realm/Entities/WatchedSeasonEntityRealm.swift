import RealmSwift

public final class WatchedSeasonEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingShowIds: ShowIdsRealm?
  @objc private dynamic var backingSeasonIds: SeasonIdsRealm?
  @objc public dynamic var backingNumber = -1
  @objc public dynamic var title: String?
  @objc public dynamic var overview: String?
  public let aired = RealmOptional<Int>()
  public let completed = RealmOptional<Int>()
  public let episodes = List<WatchedEpisodeEntityRealm>()

  public var number: Int {
    get {
      backingNumber
    }
    set {
      backingNumber = newValue
      updateIdentifier()
    }
  }

  public var showIds: ShowIdsRealm? {
    get {
      backingShowIds
    }
    set {
      backingShowIds = newValue
      updateIdentifier()
    }
  }

  public var seasonIds: SeasonIdsRealm? {
    get {
      backingSeasonIds
    }
    set {
      backingSeasonIds = newValue
      updateIdentifier()
    }
  }

  private func updateIdentifier() {
    guard let showTrakt = backingShowIds?.trakt, let seasonTrakt = backingSeasonIds?.trakt else { return }

    let typeName = String(describing: WatchedSeasonEntityRealm.self)
    identifier = "\(typeName)-\(showTrakt)-\(seasonTrakt)-\(backingNumber)"
  }

  public override static func primaryKey() -> String? {
    "identifier"
  }

  public override static func ignoredProperties() -> [String] {
    ["showIds", "number", "seasonIds"]
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? WatchedSeasonEntityRealm else { return false }

    return self == entity
  }

  public static func == (lhs: WatchedSeasonEntityRealm, rhs: WatchedSeasonEntityRealm) -> Bool {
    lhs.identifier == rhs.identifier &&
      lhs.backingShowIds == rhs.backingShowIds &&
      lhs.number == rhs.number &&
      lhs.aired.value == rhs.aired.value &&
      lhs.completed.value == rhs.completed.value &&
      lhs.episodes.toArray() == rhs.episodes.toArray()
  }
}
