import RealmSwift
import TraktSwift

final class ShowEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingIds: ShowIdsRealm?
  @objc dynamic var title: String?
  @objc dynamic var overview: String?
  @objc dynamic var network: String?
  let genres = List<GenreRealm>()
  @objc dynamic var status: String?
  @objc dynamic var firstAired: Date?

  var ids: ShowIdsRealm? {
    get {
      return backingIds
    }
    set {
      backingIds = newValue
      if let traktId = newValue?.trakt {
        let typeName = String(describing: WatchedShowEntity.self)
        identifier = "\(typeName)-\(traktId)"
      }
    }
  }

  override static func primaryKey() -> String? {
    return "identifier"
  }

  override static func ignoredProperties() -> [String] {
    return ["ids"]
  }

  override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? ShowEntityRealm else { return false }

    return self == entity
  }

  static func == (lhs: ShowEntityRealm, rhs: ShowEntityRealm) -> Bool {
    return lhs.identifier == rhs.identifier &&
      lhs.backingIds == rhs.backingIds &&
      lhs.title == rhs.title &&
      lhs.overview == rhs.overview &&
      lhs.network == rhs.network &&
      lhs.genres.toArray() == rhs.genres.toArray() &&
      lhs.status == rhs.status &&
      lhs.firstAired == rhs.firstAired
  }

  func toEntity() -> ShowEntity {
    guard let showIds = self.ids?.toEntity() else {
      Swift.fatalError("How could this be saved on Realm without primary key?!")
    }

    return ShowEntity(ids: showIds,
                      title: title,
                      overview: overview,
                      network: network,
                      genres: genres.map { $0.toEntity() },
                      status: Status(rawValue: status ?? ""),
                      firstAired: firstAired)
  }
}

extension ShowEntity {
  func toRealm() -> ShowEntityRealm {
    let entity = ShowEntityRealm()

    entity.ids = ids.toRealm()
    entity.title = title
    entity.overview = overview
    entity.network = network
    entity.status = status?.rawValue
    entity.firstAired = firstAired

    genres.forEach { entity.genres.append($0.toRealm()) }

    return entity
  }
}
