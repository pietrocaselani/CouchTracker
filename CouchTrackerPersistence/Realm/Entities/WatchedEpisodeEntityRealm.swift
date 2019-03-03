import RealmSwift

public final class WatchedEpisodeEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingEpisodeEntity: EpisodeEntityRealm?
  @objc public dynamic var lastWatched: Date?

  public var episodeEntity: EpisodeEntityRealm? {
    get {
      return backingEpisodeEntity
    }
    set {
      backingEpisodeEntity = newValue
      updateIdentifier()
    }
  }

  private func updateIdentifier() {
    guard let episodeTrakt = backingEpisodeEntity?.ids?.trakt else { return }

    let typeName = String(describing: WatchedEpisodeEntityRealm.self)
    identifier = "\(typeName)-\(episodeTrakt)"
  }

  public override static func primaryKey() -> String? {
    return "identifier"
  }

  public override static func ignoredProperties() -> [String] {
    return ["showIds", "episodeEntity"]
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? WatchedEpisodeEntityRealm else { return false }

    return self == entity
  }

  public static func == (lhs: WatchedEpisodeEntityRealm, rhs: WatchedEpisodeEntityRealm) -> Bool {
    return lhs.identifier == rhs.identifier &&
      lhs.episodeEntity == rhs.episodeEntity &&
      lhs.lastWatched == rhs.lastWatched
  }
}
