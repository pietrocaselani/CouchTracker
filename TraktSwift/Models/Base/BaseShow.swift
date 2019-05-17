import Foundation

public final class BaseShow: Codable, Hashable {
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

  private enum CodingKeys: String, CodingKey {
    case show, seasons, plays, aired, completed
    case lastCollectedAt = "last_collected_at"
    case listedAt = "listed_at"
    case lastWatchedAt = "last_watched_at"
    case hiddenSeasons = "hidden_seasons"
    case nextEpisode = "next_episode"
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    show = try container.decodeIfPresent(Show.self, forKey: .show)
    seasons = try container.decodeIfPresent([BaseSeason].self, forKey: .seasons)
    plays = try container.decodeIfPresent(Int.self, forKey: .plays)
    aired = try container.decodeIfPresent(Int.self, forKey: .aired)
    completed = try container.decodeIfPresent(Int.self, forKey: .completed)
    hiddenSeasons = try container.decodeIfPresent([Season].self, forKey: .hiddenSeasons)
    nextEpisode = try container.decodeIfPresent(Episode.self, forKey: .nextEpisode)

    let lastCollectedAt = try container.decodeIfPresent(String.self, forKey: .lastCollectedAt)
    let listedAt = try container.decodeIfPresent(String.self, forKey: .listedAt)
    let lastWatchedAt = try container.decodeIfPresent(String.self, forKey: .lastWatchedAt)

    self.lastCollectedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(lastCollectedAt)
    self.listedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(listedAt)
    self.lastWatchedAt = TraktDateTransformer.dateTimeTransformer.transformFromJSON(lastWatchedAt)
  }

  public var hashValue: Int {
    var hash = 11

    if let showHash = show?.hashValue {
      hash = hash ^ showHash
    }

    seasons?.forEach { hash = hash ^ $0.hashValue }

    if let lastCollectedAtHash = lastCollectedAt?.hashValue {
      hash = hash ^ lastCollectedAtHash
    }

    if let listedAtHash = listedAt?.hashValue {
      hash = hash ^ listedAtHash
    }

    if let playsHash = plays?.hashValue {
      hash = hash ^ playsHash
    }

    if let lastWatchedAtHash = lastWatchedAt?.hashValue {
      hash = hash ^ lastWatchedAtHash
    }

    if let airedHash = aired?.hashValue {
      hash = hash ^ airedHash
    }

    if let completedHash = completed?.hashValue {
      hash = hash ^ completedHash
    }

    hiddenSeasons?.forEach { hash = hash ^ $0.hashValue }

    if let nextEpisodeHash = nextEpisode?.hashValue {
      hash = hash ^ nextEpisodeHash
    }

    return hash
  }

  public static func == (lhs: BaseShow, rhs: BaseShow) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
