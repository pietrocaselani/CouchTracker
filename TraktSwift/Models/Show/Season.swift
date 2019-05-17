public final class Season: Codable, Hashable {
  public let number: Int
  public let ids: SeasonIds
  public let overview: String?
  public let rating: Double?
  public let votes: Int?
  public let episodeCount: Int?
  public let airedEpisodes: Int?
  public let episodes: [Episode]?
  public let title: String?

  private enum CodingKeys: String, CodingKey {
    case number, ids, overview, rating, votes, episodes, title
    case episodeCount = "episode_count"
    case airedEpisodes = "aired_episodes"
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    number = try container.decode(Int.self, forKey: .number)
    ids = try container.decode(SeasonIds.self, forKey: .ids)
    overview = try container.decodeIfPresent(String.self, forKey: .overview)
    rating = try container.decodeIfPresent(Double.self, forKey: .rating)
    votes = try container.decodeIfPresent(Int.self, forKey: .votes)
    episodeCount = try container.decodeIfPresent(Int.self, forKey: .episodeCount)
    airedEpisodes = try container.decodeIfPresent(Int.self, forKey: .airedEpisodes)
    episodes = try container.decodeIfPresent([Episode].self, forKey: .episodes)
    title = try container.decodeIfPresent(String.self, forKey: .title)
  }

  public var hashValue: Int {
    var hash = number.hashValue ^ ids.hashValue

    if let overviewHash = overview?.hashValue {
      hash = hash ^ overviewHash
    }

    if let ratingHash = rating?.hashValue {
      hash = hash ^ ratingHash
    }

    if let votesHash = votes?.hashValue {
      hash = hash ^ votesHash
    }

    if let episodeCounthash = episodeCount?.hashValue {
      hash = hash ^ episodeCounthash
    }

    if let airedEpisodesHash = airedEpisodes?.hashValue {
      hash = hash ^ airedEpisodesHash
    }

    if let titleHash = title?.hashValue {
      hash = hash ^ titleHash
    }

    episodes?.forEach { hash = hash ^ $0.hashValue }

    return hash
  }

  public static func == (lhs: Season, rhs: Season) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
