import RealmSwift

final class EpisodeEntityRealm: Object {
  @objc private dynamic var identifier = 0
  @objc private dynamic var backingIds: EpisodeIdsRealm?
  @objc dynamic var showIds: ShowIdsRealm?
  @objc dynamic var title: String = ""
  @objc dynamic var overview: String?
  @objc dynamic var number = -1
  @objc dynamic var season = -1
  @objc dynamic var firstAired: Date?
  @objc dynamic var lastWatched: Date?

  var ids: EpisodeIdsRealm? {
    get {
      return backingIds
    }
    set {
      backingIds = newValue
      if let newValueHash = newValue?.hashValue {
        identifier = newValueHash
      }
    }
  }

  override static func primaryKey() -> String? {
    return "identifier"
  }

  override static func ignoredProperties() -> [String] {
    return ["backingIds"]
  }

  func toEntity() -> EpisodeEntity {
    guard let showIds = self.showIds?.toEntity() else {
      Swift.fatalError("How showIds is not present on EpisodeEntityRealm?!")
    }

    guard let ids = self.ids?.toEntity() else {
      Swift.fatalError("How ids is not present on EpisodeEntityRealm?!")
    }

    return EpisodeEntity(ids: ids,
                  showIds: showIds,
                  title: self.title,
                  overview: self.overview,
                  number: self.number,
                  season: self.season,
                  firstAired: self.firstAired,
                  lastWatched: self.lastWatched)
  }
}

extension EpisodeEntity {
  func toRealm() -> EpisodeEntityRealm {
    let entity = EpisodeEntityRealm()

    entity.ids = self.ids.toRealm()
    entity.showIds = self.showIds.toRealm()
    entity.title = self.title
    entity.overview = self.overview
    entity.number = self.number
    entity.season = self.season
    entity.firstAired = self.firstAired
    entity.lastWatched = self.lastWatched

    return entity
  }
}