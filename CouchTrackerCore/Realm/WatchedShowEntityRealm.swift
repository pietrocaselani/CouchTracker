import RealmSwift

final class WatchedShowEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingShow: ShowEntityRealm?
  @objc dynamic var nextEpisode: WatchedEpisodeEntityRealm?
  @objc dynamic var lastWatched: Date?
  let aired = RealmOptional<Int>()
  let completed = RealmOptional<Int>()
  let seasons = List<WatchedSeasonEntityRealm>()

  var show: ShowEntityRealm? {
    get {
      return backingShow
    }
    set {
      backingShow = newValue
      if let traktId = newValue?.ids?.trakt {
        let typeName = String(describing: WatchedShowEntity.self)
        identifier = "\(typeName)-\(traktId)"
      }
    }
  }

  override static func primaryKey() -> String? {
    return "identifier"
  }

  override static func ignoredProperties() -> [String] {
    return ["show"]
  }

  override func isEqual(_ object: Any?) -> Bool {
    guard let entity = object as? WatchedShowEntityRealm else { return false }

    return self == entity
  }

  static func == (lhs: WatchedShowEntityRealm, rhs: WatchedShowEntityRealm) -> Bool {
    return lhs.identifier == rhs.identifier &&
      lhs.backingShow == rhs.backingShow &&
      lhs.aired.value == rhs.aired.value &&
      lhs.completed.value == rhs.completed.value &&
      lhs.nextEpisode == rhs.nextEpisode &&
      lhs.lastWatched == rhs.lastWatched
  }

  func toEntity() -> WatchedShowEntity {
    guard let show = self.show?.toEntity() else {
      Swift.fatalError("How show is not present on EpisodeEntityRealm?!")
    }

    return WatchedShowEntity(show: show,
                             aired: aired.value,
                             completed: completed.value,
                             nextEpisode: nextEpisode?.toEntity(),
                             lastWatched: lastWatched,
                             seasons: seasons.map { $0.toEntity() })
  }
}

extension WatchedShowEntity {
  func toRealm() -> WatchedShowEntityRealm {
    let entity = WatchedShowEntityRealm()

    entity.show = show.toRealm()
    entity.aired.value = aired
    entity.completed.value = completed
    entity.nextEpisode = nextEpisode?.toRealm()
    entity.lastWatched = lastWatched
    entity.seasons.append(objectsIn: seasons.map { $0.toRealm() })

    return entity
  }
}
