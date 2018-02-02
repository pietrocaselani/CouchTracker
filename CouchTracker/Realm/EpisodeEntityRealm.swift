import RealmSwift

final class EpisodeEntityRealm: Object {
  @objc dynamic var ids: EpisodeIdsRealm?
  @objc dynamic var showIds: ShowIdsRealm?
  @objc dynamic var title: String = ""
  @objc dynamic var overview: String?
  @objc dynamic var number = -1
  @objc dynamic var season = -1
  @objc dynamic var firstAired: Date?
  @objc dynamic var lastWatched: Date?

  override static func primaryKey() -> String? {
    return "ids"
  }
}
