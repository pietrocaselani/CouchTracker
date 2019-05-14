public final class TrendingMovie: BaseTrendingEntity {
  public let movie: Movie

  private enum CodingKeys: String, CodingKey {
    case movie
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    movie = try container.decode(Movie.self, forKey: .movie)

    try super.init(from: decoder)
  }

  public override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(movie, forKey: .movie)

    try super.encode(to: encoder)
  }

  public override var hashValue: Int {
    return super.hashValue ^ movie.hashValue
  }
}
