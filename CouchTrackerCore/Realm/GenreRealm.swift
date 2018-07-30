import RealmSwift
import TraktSwift

final class GenreRealm: Object {
    @objc dynamic var name = ""
    @objc dynamic var slug = ""

    override static func primaryKey() -> String? {
        return "slug"
    }

    func toEntity() -> Genre {
        return Genre(name: name, slug: slug)
    }
}

extension Genre {
    func toRealm() -> GenreRealm {
        let entity = GenreRealm()

        entity.name = name
        entity.slug = slug

        return entity
    }
}
