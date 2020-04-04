import RealmSwift

public final class WatchedEpisodeRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingEpisode: EpisodeRealm?
  @objc public dynamic var lastWatched: Date?

  public var episode: EpisodeRealm? {
    get { backingEpisode }
    set {
      backingEpisode = newValue
      updateIdentifier()
    }
  }

  private func updateIdentifier() {
    guard let episodeTrakt = backingEpisode?.ids?.trakt else { return }

    let typeName = String(describing: WatchedEpisodeRealm.self)
    identifier = "\(typeName)-\(episodeTrakt)"
  }

  public override static func primaryKey() -> String? {
    "identifier"
  }

  public override static func ignoredProperties() -> [String] {
    ["showIds", "episodeEntity"]
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? WatchedEpisodeRealm else { return false }

    return self == entity
  }

  public static func == (lhs: WatchedEpisodeRealm, rhs: WatchedEpisodeRealm) -> Bool {
    lhs.identifier == rhs.identifier &&
      lhs.episode == rhs.episode &&
      lhs.lastWatched == rhs.lastWatched
  }
}
