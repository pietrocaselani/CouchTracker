import RealmSwift

public final class EpisodeRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingIds: EpisodeIdsRealm?
  @objc public dynamic var showIds: ShowIdsRealm?
  @objc public dynamic var title: String = ""
  @objc public dynamic var overview: String?
  @objc public dynamic var number = -1
  @objc public dynamic var season = -1
  @objc public dynamic var firstAired: Date?
  public var absoluteNumber = RealmOptional<Int>()
  public var runtime = RealmOptional<Int>()
  public var rating = RealmOptional<Double>()
  public var votes = RealmOptional<Int>()

  public var ids: EpisodeIdsRealm? {
    get { backingIds }
    set {
      backingIds = newValue
      if let traktId = newValue?.trakt {
        let typeName = String(describing: EpisodeRealm.self)
        identifier = "\(typeName)-\(traktId)"
      }
    }
  }

  public override static func primaryKey() -> String? {
    "identifier"
  }

  public override static func ignoredProperties() -> [String] {
    ["ids"]
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? EpisodeRealm else { return false }

    return self == entity
  }

  public static func == (lhs: EpisodeRealm, rhs: EpisodeRealm) -> Bool {
    lhs.identifier == rhs.identifier &&
      lhs.backingIds == rhs.backingIds &&
      lhs.showIds == rhs.showIds &&
      lhs.title == rhs.title &&
      lhs.overview == rhs.overview &&
      lhs.number == rhs.number &&
      lhs.season == rhs.season &&
      lhs.firstAired == rhs.firstAired &&
      lhs.absoluteNumber.value == rhs.absoluteNumber.value &&
      lhs.runtime.value == rhs.runtime.value &&
      lhs.rating.value == rhs.rating.value &&
      lhs.votes.value == rhs.votes.value
  }
}
