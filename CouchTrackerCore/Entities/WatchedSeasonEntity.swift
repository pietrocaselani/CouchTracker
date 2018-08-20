import TraktSwift

public struct WatchedSeasonEntity: Hashable {
  public let showIds: ShowIds
  public let seasonIds: SeasonIds
  public let number: Int
  public let aired: Int?
  public let completed: Int?
  public let episodes: [WatchedEpisodeEntity]
  public let special: Bool
  public let overview: String?
  public let title: String?

  init(showIds: ShowIds, seasonIds: SeasonIds, number: Int, aired: Int?, completed: Int?,
       episodes: [WatchedEpisodeEntity], special: Bool, overview: String?, title: String?) {
    self.showIds = showIds
    self.seasonIds = seasonIds
    self.number = number
    self.aired = aired
    self.completed = completed
    self.episodes = episodes
    self.special = special
    self.overview = overview
    self.title = title
  }

  public var hashValue: Int {
    var hash = showIds.hashValue
    hash ^= seasonIds.hashValue
    hash ^= number.hashValue
    hash ^= special.hashValue
    aired.run { hash ^= $0.hashValue }
    completed.run { hash ^= $0.hashValue }
    overview.run { hash ^= $0.hashValue }
    title.run { hash ^= $0.hashValue }
    episodes.forEach { hash ^= $0.hashValue }

    return hash
  }

  public static func == (lhs: WatchedSeasonEntity, rhs: WatchedSeasonEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
