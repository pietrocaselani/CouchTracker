public class BaseIds: Codable, Hashable, CustomStringConvertible {
  public let trakt: Int
  public let tmdb: Int?
  public let imdb: String?

  private enum CodingKeys: String, CodingKey {
    case trakt, tmdb, imdb
  }

  public init(trakt: Int, tmdb: Int?, imdb: String?) {
    self.trakt = trakt
    self.tmdb = tmdb
    self.imdb = imdb
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    trakt = try container.decode(Int.self, forKey: .trakt)
    tmdb = try container.decodeIfPresent(Int.self, forKey: .tmdb)
    imdb = try container.decodeIfPresent(String.self, forKey: .imdb)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(trakt, forKey: .trakt)
    try container.encodeIfPresent(tmdb, forKey: .tmdb)
    try container.encodeIfPresent(imdb, forKey: .imdb)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(trakt)
    hasher.combine(tmdb)
    hasher.combine(imdb)
  }

  public static func == (lhs: BaseIds, rhs: BaseIds) -> Bool {
    return lhs.trakt == rhs.trakt &&
      lhs.tmdb == rhs.tmdb &&
      lhs.imdb == rhs.imdb
  }

  public var description: String {
    return "trakt: \(trakt), tmdb: \(String(describing: tmdb)), imdb: \(String(describing: imdb))"
  }
}
