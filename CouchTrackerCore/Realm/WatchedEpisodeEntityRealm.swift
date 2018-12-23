import RealmSwift
import TraktSwift

final class WatchedEpisodeEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingEpisodeEntity: EpisodeEntityRealm?
  @objc dynamic var lastWatched: Date?

  var episodeEntity: EpisodeEntityRealm? {
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

    let typeName = String(describing: WatchedEpisodeEntity.self)
    identifier = "\(typeName)-\(episodeTrakt)"
  }

  override static func primaryKey() -> String? {
    return "identifier"
  }

  override static func ignoredProperties() -> [String] {
    return ["showIds", "episodeEntity"]
  }

  override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? WatchedEpisodeEntityRealm else { return false }

    return self == entity
  }

  static func == (lhs: WatchedEpisodeEntityRealm, rhs: WatchedEpisodeEntityRealm) -> Bool {
    return lhs.identifier == rhs.identifier &&
      lhs.episodeEntity == rhs.episodeEntity &&
      lhs.lastWatched == rhs.lastWatched
  }

  func toEntity() -> WatchedEpisodeEntity {
    guard let episode = episodeEntity?.toEntity() else {
      Swift.fatalError("How episodeEntity is not present on WatchedEpisodeEntityRealm?!")
    }

    return WatchedEpisodeEntity(episode: episode, lastWatched: lastWatched)
  }
}

extension WatchedEpisodeEntity {
  func toRealm() -> WatchedEpisodeEntityRealm {
    let realm = WatchedEpisodeEntityRealm()

    realm.episodeEntity = episode.toRealm()
    realm.lastWatched = lastWatched

    return realm
  }
}
