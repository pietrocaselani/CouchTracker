import RealmSwift

final class GenreRealm: Object {
  @objc dynamic var name = ""
  @objc dynamic var slug = ""

  override static func primaryKey() -> String? {
    return "slug"
  }
}
