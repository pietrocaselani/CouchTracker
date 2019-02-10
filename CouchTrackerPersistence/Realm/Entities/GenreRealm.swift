import RealmSwift

public final class GenreRealm: Object {
  @objc public dynamic var name = ""
  @objc public dynamic var slug = ""

  public override static func primaryKey() -> String? {
    return "slug"
  }
}
