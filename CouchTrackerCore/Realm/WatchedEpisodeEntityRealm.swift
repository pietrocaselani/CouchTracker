import RealmSwift
import TraktSwift

final class WatchedEpisodeEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingShowIds: ShowIdsRealm?
  @objc dynamic var backingNumber = -1
  @objc dynamic var lastWatchedAt: Date?

  var number: Int {
    get {
      return backingNumber
    }
    set {
      backingNumber = newValue
      updateIdentifier()
    }
  }

  var showIds: ShowIdsRealm? {
    get {
      return backingShowIds
    }
    set {
      backingShowIds = newValue
      updateIdentifier()
    }
  }

  private func updateIdentifier() {
    if let traktId = backingShowIds?.trakt {
      let typeName = String(describing: WatchedEpisodeEntity.self)
      identifier = "\(typeName)-\(traktId)-\(number)"
    }
  }

  override static func primaryKey() -> String? {
    return "identifier"
  }

  override static func ignoredProperties() -> [String] {
    return ["showIds", "number"]
  }

  override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? WatchedEpisodeEntityRealm else { return false }

    return self == entity
  }

  static func == (lhs: WatchedEpisodeEntityRealm, rhs: WatchedEpisodeEntityRealm) -> Bool {
    return lhs.identifier == rhs.identifier &&
      lhs.backingShowIds == rhs.backingShowIds &&
      lhs.number == rhs.number &&
      lhs.lastWatchedAt == rhs.lastWatchedAt
  }

  func toEntity() -> WatchedEpisodeEntity {
    guard let showIds = showIds?.toEntity() else {
      Swift.fatalError("How show is not present on WatchedEpisodeEntityRealm?!")
    }

    return WatchedEpisodeEntity(showIds: showIds, number: number, lastWatchedAt: lastWatchedAt)
  }
}

extension WatchedEpisodeEntity {
  func toRealm() -> WatchedEpisodeEntityRealm {
    let realm = WatchedEpisodeEntityRealm()

    realm.showIds = showIds.toRealm()
    realm.number = number
    realm.lastWatchedAt = lastWatchedAt

    return realm
  }
}
