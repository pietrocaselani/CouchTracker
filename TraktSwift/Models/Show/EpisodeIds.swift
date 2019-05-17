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

  public override var hashValue: Int {
    var hash = super.hashValue

    if let tvdbHash = tvdb?.hashValue {
      hash ^= tvdbHash
    }

    if let tvrageHash = tvrage?.hashValue {
      hash ^= tvrageHash
    }
    return hash
  }

  public override var description: String {
    return "\(super.description), tvdb: \(String(describing: tvdb)), tvrage: \(String(describing: tvrage))"
  }
}
