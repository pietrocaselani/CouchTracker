import RealmSwift

final class WatchedShowEntityRealm: Object {
  @objc private dynamic var identifier = ""
  @objc private dynamic var backingShow: ShowEntityRealm?
  @objc dynamic var aired = -1
  @objc dynamic var completed = -1
  @objc dynamic var nextEpisode: EpisodeEntityRealm?
  @objc dynamic var lastWatched: Date?

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
    return ["backingShow"]
  }

  func toEntity() -> WatchedShowEntity {
    guard let show = self.show?.toEntity() else {
      Swift.fatalError("How show is not present on EpisodeEntityRealm?!")
    }

    return WatchedShowEntity(show: show,
                             aired: self.aired,
                             completed: self.completed,
                             nextEpisode: self.nextEpisode?.toEntity(),
                             lastWatched: self.lastWatched)
  }
}

extension WatchedShowEntity {
  func toRealm() -> WatchedShowEntityRealm {
    let entity = WatchedShowEntityRealm()

    entity.show = self.show.toRealm()
    entity.aired = self.aired
    entity.completed = self.completed
    entity.nextEpisode = self.nextEpisode?.toRealm()
    entity.lastWatched = self.lastWatched

    return entity
  }
}
