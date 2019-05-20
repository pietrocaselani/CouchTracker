public struct SearchResult: Codable, Hashable {
  public let type: SearchType
  public let score: Double?
  public let movie: Movie?
  public let show: Show?

  private enum CodingKeys: String, CodingKey {
    case type, score, movie, show
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    type = try container.decodeIfPresent(SearchType.self, forKey: .type) ?? .none
    score = try container.decodeIfPresent(Double.self, forKey: .score)
    movie = try container.decodeIfPresent(Movie.self, forKey: .movie)
    show = try container.decodeIfPresent(Show.self, forKey: .show)
  }
}
