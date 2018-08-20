import TraktSwift

public final class WatchedSeasonEntityBuilder: Hashable {
  public let showIds: ShowIds
  public let special: Bool
  public var progressSeason: BaseSeason?
  public var detailSeason: Season?
  public var episodes: [WatchedEpisodeEntityBuilder]?

  public init(showIds: ShowIds, special: Bool) {
    self.showIds = showIds
    self.special = special
  }

  @discardableResult
  public func set(progressSeason: BaseSeason?) -> WatchedSeasonEntityBuilder {
    self.progressSeason = progressSeason
    return self
  }

  @discardableResult
  public func set(episodes: [WatchedEpisodeEntityBuilder]?) -> WatchedSeasonEntityBuilder {
    self.episodes = episodes
    return self
  }

  @discardableResult
  public func set(detailSeason: Season?) -> WatchedSeasonEntityBuilder {
    self.detailSeason = detailSeason
    return self
  }

  public func createEntity() -> WatchedSeasonEntity {
    guard let detailSeason = self.detailSeason else { Swift.fatalError("detailSeason can't be nil") }

    let episodeEntities = episodes?.map { $0.createEntity() } ?? [WatchedEpisodeEntity]()

    return WatchedSeasonEntity(showIds: showIds, seasonIds: detailSeason.ids, number: detailSeason.number,
                               aired: progressSeason?.aired, completed: progressSeason?.completed,
                               episodes: episodeEntities, special: special,
                               overview: detailSeason.overview, title: detailSeason.title)
  }

  public var hashValue: Int {
    var hash = showIds.hashValue ^ special.hashValue

    progressSeason.run { hash ^= $0.hashValue }
    detailSeason.run { hash ^= $0.hashValue }

    episodes?.forEach { hash ^= $0.hashValue }

    return hash
  }

  public static func == (lhs: WatchedSeasonEntityBuilder, rhs: WatchedSeasonEntityBuilder) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
