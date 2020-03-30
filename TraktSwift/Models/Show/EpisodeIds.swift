public final class EpisodeIds: BaseIds {
  public let tvdb: Int?
  public let tvrage: Int?

  private enum CodingKeys: String, CodingKey {
    case tvdb, tvrage
  }

  public init(trakt: Int, tmdb: Int?, imdb: String?, tvdb: Int?, tvrage: Int?) {
    self.tvdb = tvdb
    self.tvrage = tvrage
    super.init(trakt: trakt, tmdb: tmdb, imdb: imdb)
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    tvdb = try container.decodeIfPresent(Int.self, forKey: .tvdb)
    tvrage = try container.decodeIfPresent(Int.self, forKey: .tvrage)

    try super.init(from: decoder)
  }

  public override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(tvdb, forKey: .tvdb)
    try container.encodeIfPresent(tvrage, forKey: .tvrage)

    try super.encode(to: encoder)
  }

  public override func hash(into hasher: inout Hasher) {
    super.hash(into: &hasher)
    hasher.combine(tvdb)
    hasher.combine(tvrage)
  }

  public static func == (lhs: EpisodeIds, rhs: EpisodeIds) -> Bool {
    let lhsBaseIds = lhs as BaseIds
    let rhsBaseIds = rhs as BaseIds

    return lhsBaseIds == rhsBaseIds && lhs.tvdb == rhs.tvdb && lhs.tvrage == rhs.tvrage
  }

  public override var description: String {
    "\(super.description), tvdb: \(String(describing: tvdb)), tvrage: \(String(describing: tvrage))"
  }
}
