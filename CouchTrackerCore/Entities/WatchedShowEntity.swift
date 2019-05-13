import Foundation

public struct WatchedShowEntity: Hashable, Codable {
  public let show: ShowEntity
  public let aired: Int?
  public let completed: Int?
  public let nextEpisode: WatchedEpisodeEntity?
  public let lastWatched: Date?
  public let seasons: [WatchedSeasonEntity]

  public init(show: ShowEntity, aired: Int?, completed: Int?,
              nextEpisode: WatchedEpisodeEntity?, lastWatched: Date?, seasons: [WatchedSeasonEntity]) {
    self.show = show
    self.aired = aired
    self.completed = completed
    self.nextEpisode = nextEpisode
    self.lastWatched = lastWatched
    self.seasons = seasons
  }
}
