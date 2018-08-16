import RealmSwift
import TraktSwift

final class WatchedSeasonEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingShowIds: ShowIdsRealm?
  @objc dynamic var backingNumber = -1
  let aired = RealmOptional<Int>()
  let completed = RealmOptional<Int>()
  let episodes = List<WatchedEpisodeEntityRealm>()

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
      let typeName = String(describing: WatchedSeasonEntity.self)
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
    guard let entity = object as? WatchedSeasonEntityRealm else { return false }

    return self == entity
  }

  static func == (lhs: WatchedSeasonEntityRealm, rhs: WatchedSeasonEntityRealm) -> Bool {
    return lhs.identifier == rhs.identifier &&
      lhs.backingShowIds == rhs.backingShowIds &&
      lhs.number == rhs.number &&
      lhs.aired.value == rhs.aired.value &&
      lhs.completed.value == rhs.completed.value &&
      lhs.episodes.toArray() == rhs.episodes.toArray()
  }

  func toEntity() -> WatchedSeasonEntity {
    guard let showIds = showIds?.toEntity() else {
      Swift.fatalError("How show is not present on WatchedSeasonEntityRealm?!")
    }

    // CT-TODO
    let seasonIds = SeasonIds(tvdb: 0, tmdb: 0, trakt: 0, tvrage: 0)

    return WatchedSeasonEntity(showIds: showIds,
                               seasonIds: seasonIds,
                               number: number,
                               aired: aired.value,
                               completed: completed.value,
                               episodes: episodes.map { $0.toEntity() })
  }
}

extension WatchedSeasonEntity {
  func toRealm() -> WatchedSeasonEntityRealm {
    let realm = WatchedSeasonEntityRealm()

    realm.showIds = showIds.toRealm()
    realm.number = number
    realm.aired.value = aired
    realm.completed.value = completed
    realm.episodes.append(objectsIn: episodes.map { $0.toRealm() })

    return realm
  }
}
