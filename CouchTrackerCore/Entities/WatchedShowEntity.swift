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

  public var hashValue: Int {
    var hash = show.hashValue
    aired.run { hash ^= $0.hashValue }
    completed.run { hash ^= $0.hashValue }
    nextEpisode.run { hash ^= $0.hashValue }
    lastWatched.run { hash ^= $0.hashValue }
    seasons.forEach { hash ^= $0.hashValue }
    return hash
  }

  public static func == (lhs: WatchedShowEntity, rhs: WatchedShowEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
