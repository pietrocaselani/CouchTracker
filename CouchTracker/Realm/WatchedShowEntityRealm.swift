import RealmSwift

final class WatchedShowEntityRealm: Object {
  @objc dynamic var show: ShowEntityRealm?
  @objc dynamic var aired = -1
  @objc dynamic var completed = -1
  @objc dynamic var nextEpisode: EpisodeEntityRealm?
  @objc dynamic var lastWatched: Date?

  override static func primaryKey() -> String? {
    return "show"
  }
}
