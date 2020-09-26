public struct Season: Codable, Hashable {
  public let number: Int
  public let ids: SeasonIds
  public let overview: String?
  public let rating: Double?
  public let votes: Int?
  public let episodeCount: Int?
  public let airedEpisodes: Int?
  public let episodes: [Episode]?
  public let title: String?
  public let firstAired: Date?
  public let network: String?

  private enum CodingKeys: String, CodingKey {
    case number, ids, overview, rating, votes, episodes, title, network
    case episodeCount = "episode_count"
    case airedEpisodes = "aired_episodes"
    case firstAired = "first_aired"
  }

  public init(from decoder: Decoder) throws {
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
    network = try container.decodeIfPresent(String.self, forKey: .network)

    let firstAired = try container.decodeIfPresent(String.self, forKey: .firstAired)
    self.firstAired = TraktDateTransformer.dateTimeTransformer.transformFromJSON(firstAired)
  }
}
