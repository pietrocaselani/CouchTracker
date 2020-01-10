import Foundation

public struct BaseShow: Codable, Hashable {
  public let show: Show?
  public let seasons: [BaseSeason]?
  public let lastCollectedAt: Date?
  public let listedAt: Date?
  public let plays: Int?
  public let lastWatchedAt: Date?
  public let aired: Int?
  public let completed: Int?
  public let hiddenSeasons: [Season]?
  public let nextEpisode: Episode?
  public let lastEpisode: Episode?

  private enum CodingKeys: String, CodingKey {
    case show, seasons, plays, aired, completed
    case lastCollectedAt = "last_collected_at"
    case listedAt = "listed_at"
    case lastWatchedAt = "last_watched_at"
    case hiddenSeasons = "hidden_seasons"
    case nextEpisode = "next_episode"
    case lastEpisode = "last_episode"
  }

  public init(show: Show? = nil,
              seasons: [BaseSeason]? = nil,
              lastCollectedAt: Date? = nil,
              listedAt: Date? = nil,
              plays: Int? = nil,
              lastWatchedAt: Date? = nil,
              aired: Int? = nil,
              completed: Int? = nil,
              hiddenSeasons: [Season]? = nil,
              nextEpisode: Episode? = nil,
              lastEpisode: Episode? = nil) {
    self.show = show
    self.seasons = seasons
    self.lastCollectedAt = lastCollectedAt
    self.listedAt = listedAt
    self.plays = plays
    self.lastWatchedAt = lastWatchedAt
    self.aired = aired
    self.completed = completed
    self.hiddenSeasons = hiddenSeasons
    self.nextEpisode = nextEpisode
    self.lastEpisode = lastEpisode
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    show = try container.decodeIfPresent(Show.self, forKey: .show)
    seasons = try container.decodeIfPresent([BaseSeason].self, forKey: .seasons)
    plays = try container.decodeIfPresent(Int.self, forKey: .plays)
    aired = try container.decodeIfPresent(Int.self, forKey: .aired)
    completed = try container.decodeIfPresent(Int.self, forKey: .completed)
    hiddenSeasons = try container.decodeIfPresent([Season].self, forKey: .hiddenSeasons)
    nextEpisode = try container.decodeIfPresent(Episode.self, forKey: .nextEpisode)
    lastEpisode = try container.decodeIfPresent(Episode.self, forKey: .lastEpisode)

    let lastCollectedAt = try container.decodeIfPresent(String.self, forKey: .lastCollectedAt)
    let listedAt = try container.decodeIfPresent(String.self, forKey: .listedAt)
    let lastWatchedAt = try container.decodeIfPresent(String.self, forKey: .lastWatchedAt)

    self.lastCollectedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(lastCollectedAt)
    self.listedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(listedAt)
    self.lastWatchedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(lastWatchedAt)
  }
}
