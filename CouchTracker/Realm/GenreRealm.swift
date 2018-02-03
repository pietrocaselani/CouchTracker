import RealmSwift
import TraktSwift

final class GenreRealm: Object {
  @objc dynamic var name = ""
  @objc dynamic var slug = ""

  override static func primaryKey() -> String? {
    return "slug"
  }

  func toEntity() -> Genre {
    return Genre(name: self.name, slug: self.slug)
  }
}

extension Genre {
  convenience init(name: String, slug: String) {
    self.init(name: name, slug: slug)
  }

  func toRealm() -> GenreRealm {
    let entity = GenreRealm()

    entity.name = self.name
    entity.slug = self.slug

    return entity
  }
}
