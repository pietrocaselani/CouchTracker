public struct SyncStats: Codable {
  public let movies, shows, seasons, episodes: Int?

  private enum CodingKeys: String, CodingKey {
    case movies, shows, seasons, episodes
  }

  public init(movies: Int?, shows: Int?, seasons: Int?, episodes: Int?) {
    self.movies = movies
    self.shows = shows
    self.seasons = seasons
    self.episodes = episodes
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    movies = try container.decodeIfPresent(Int.self, forKey: .movies)
    shows = try container.decodeIfPresent(Int.self, forKey: .shows)
    seasons = try container.decodeIfPresent(Int.self, forKey: .seasons)
    episodes = try container.decodeIfPresent(Int.self, forKey: .episodes)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(movies, forKey: .movies)
    try container.encodeIfPresent(shows, forKey: .shows)
    try container.encodeIfPresent(seasons, forKey: .seasons)
    try container.encodeIfPresent(episodes, forKey: .episodes)
  }
}
