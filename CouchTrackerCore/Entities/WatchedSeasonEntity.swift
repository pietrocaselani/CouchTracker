import TraktSwift

public struct WatchedSeasonEntity: Hashable, Codable {
  public let showIds: ShowIds
  public let seasonIds: SeasonIds
  public let number: Int
  public let aired: Int?
  public let completed: Int?
  public let episodes: [WatchedEpisodeEntity]
  public let overview: String?
  public let title: String?

  public init(showIds: ShowIds, seasonIds: SeasonIds, number: Int, aired: Int?, completed: Int?,
              episodes: [WatchedEpisodeEntity], overview: String?, title: String?) {
    self.showIds = showIds
    self.seasonIds = seasonIds
    self.number = number
    self.aired = aired
    self.completed = completed
    self.episodes = episodes
    self.overview = overview
    self.title = title
  }
}
