import TraktSwift

public struct WatchedSeasonEntityBuilder: Hashable {
  public let showIds: ShowIds
  public var progressSeason: BaseSeason?
  public var detailSeason: Season?
  public var episodes: [WatchedEpisodeEntityBuilder]?

  public init(showIds: ShowIds, progressSeason: BaseSeason? = nil,
              detailSeason: Season? = nil, episodes: [WatchedEpisodeEntityBuilder]? = nil) {
    self.showIds = showIds
    self.progressSeason = progressSeason
    self.detailSeason = detailSeason
    self.episodes = episodes
  }

  public func set(progressSeason: BaseSeason?) -> WatchedSeasonEntityBuilder {
    WatchedSeasonEntityBuilder(showIds: showIds,
                                      progressSeason: progressSeason,
                                      detailSeason: detailSeason,
                                      episodes: episodes)
  }

  public func set(episodes: [WatchedEpisodeEntityBuilder]?) -> WatchedSeasonEntityBuilder {
    WatchedSeasonEntityBuilder(showIds: showIds,
                                      progressSeason: progressSeason,
                                      detailSeason: detailSeason,
                                      episodes: episodes)
  }

  public func set(detailSeason: Season?) -> WatchedSeasonEntityBuilder {
    WatchedSeasonEntityBuilder(showIds: showIds,
                                      progressSeason: progressSeason,
                                      detailSeason: detailSeason,
                                      episodes: episodes)
  }

  public func createEntity() -> WatchedSeasonEntity {
    guard let detailSeason = self.detailSeason else { Swift.fatalError("detailSeason can't be nil") }

    let episodeEntities = episodes?.map { $0.createEntity() } ?? [WatchedEpisodeEntity]()

    return WatchedSeasonEntity(showIds: showIds, seasonIds: detailSeason.ids, number: detailSeason.number,
                               aired: progressSeason?.aired, completed: progressSeason?.completed,
                               episodes: episodeEntities, overview: detailSeason.overview, title: detailSeason.title)
  }
}
