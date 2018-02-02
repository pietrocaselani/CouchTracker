import RealmSwift

final class ShowIdsRealm: Object {
  @objc dynamic var trakt = -1
  let tmdb = RealmOptional<Int>()
  @objc dynamic var imdb: String?
  @objc dynamic var slug = ""
  @objc dynamic var tvdb = -1
  let tvrage = RealmOptional<Int>()

  override static func primaryKey() -> String? {
    return "trakt"
  }
}
