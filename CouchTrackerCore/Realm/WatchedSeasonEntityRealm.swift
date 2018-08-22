import RealmSwift
import TraktSwift

final class WatchedSeasonEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingShowIds: ShowIdsRealm?
  @objc private dynamic var backingSeasonIds: SeasonIdsRealm?
  @objc dynamic var backingNumber = -1
  @objc dynamic var title: String?
  @objc dynamic var overview: String?
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

  var seasonIds: SeasonIdsRealm? {
    get {
      return backingSeasonIds
    }
    set {
      backingSeasonIds = newValue
      updateIdentifier()
    }
  }

  private func updateIdentifier() {
    guard let showTrakt = backingShowIds?.trakt, let seasonTrakt = backingSeasonIds?.trakt else { return }

    let typeName = String(describing: WatchedSeasonEntity.self)
    identifier = "\(typeName)-\(showTrakt)-\(seasonTrakt)-\(backingNumber)"
  }

  override static func primaryKey() -> String? {
    return "identifier"
  }

  override static func ignoredProperties() -> [String] {
    return ["showIds", "number", "seasonIds"]
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
    guard let seasonIds = backingSeasonIds?.toEntity(), let showIds = backingShowIds?.toEntity() else {
      Swift.fatalError("")
    }

    return WatchedSeasonEntity(showIds: showIds, seasonIds: seasonIds, number: number, aired: aired.value,
                               completed: completed.value, episodes: episodes.map { $0.toEntity() },
                               overview: overview, title: title)
  }
}

extension WatchedSeasonEntity {
  func toRealm() -> WatchedSeasonEntityRealm {
    let realm = WatchedSeasonEntityRealm()

    realm.showIds = showIds.toRealm()
    realm.seasonIds = seasonIds.toRealm()
    realm.title = title
    realm.overview = overview
    realm.number = number
    realm.aired.value = aired
    realm.completed.value = completed
    realm.episodes.append(objectsIn: episodes.map { $0.toRealm() })

    return realm
  }
}
