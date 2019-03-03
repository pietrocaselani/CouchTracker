import RealmSwift

public final class ShowEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingIds: ShowIdsRealm?
  @objc public dynamic var title: String?
  @objc public dynamic var overview: String?
  @objc public dynamic var network: String?
  public let genres = List<GenreRealm>()
  @objc public dynamic var status: String?
  @objc public dynamic var firstAired: Date?

  public var ids: ShowIdsRealm? {
    get {
      return backingIds
    }
    set {
      backingIds = newValue
      if let traktId = newValue?.trakt {
        let typeName = String(describing: WatchedShowEntityRealm.self)
        identifier = "\(typeName)-\(traktId)"
      }
    }
  }

  public override static func primaryKey() -> String? {
    return "identifier"
  }

  public override static func ignoredProperties() -> [String] {
    return ["ids"]
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? ShowEntityRealm else { return false }

    return self == entity
  }

  public static func == (lhs: ShowEntityRealm, rhs: ShowEntityRealm) -> Bool {
    return lhs.identifier == rhs.identifier &&
      lhs.backingIds == rhs.backingIds &&
      lhs.title == rhs.title &&
      lhs.overview == rhs.overview &&
      lhs.network == rhs.network &&
      lhs.genres.toArray() == rhs.genres.toArray() &&
      lhs.status == rhs.status &&
      lhs.firstAired == rhs.firstAired
  }
}
