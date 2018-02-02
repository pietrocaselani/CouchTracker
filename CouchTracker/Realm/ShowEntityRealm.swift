import RealmSwift

final class ShowEntityRealm: Object {
  @objc dynamic var ids: ShowIdsRealm?
  @objc dynamic var title: String?
  @objc dynamic var overview: String?
  @objc dynamic var network: String?
  let genres = List<GenreRealm>()
  @objc dynamic var status: String?
  @objc dynamic var firstAired: Date?

  override static func primaryKey() -> String? {
    return "ids"
  }
}
