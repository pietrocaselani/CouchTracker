public final class ShowIds: BaseIds {
  public let slug: String
  public let tvdb: Int
  public let tvrage: Int?

  public var realId: String {
    return String(trakt)
  }

  private enum CodingKeys: String, CodingKey {
    case slug, tvdb, tvrage
  }

  public init(trakt: Int, tmdb: Int?, imdb: String?, slug: String, tvdb: Int, tvrage: Int?) {
    self.slug = slug
    self.tvdb = tvdb
    self.tvrage = tvrage
    super.init(trakt: trakt, tmdb: tmdb, imdb: imdb)
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    slug = try container.decode(String.self, forKey: .slug)
    tvdb = try container.decode(Int.self, forKey: .tvdb)
    tvrage = try container.decodeIfPresent(Int.self, forKey: .tvrage)

    try super.init(from: decoder)
  }

  public override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(slug, forKey: .slug)
    try container.encode(tvdb, forKey: .tvdb)
    try container.encodeIfPresent(tvrage, forKey: .tvrage)

    try super.encode(to: encoder)
  }

  public override var hashValue: Int {
    var hash = super.hashValue ^ slug.hashValue ^ tvdb.hashValue
    if let tvrageHash = tvrage?.hashValue {
      hash = hash ^ tvrageHash
    }
    return hash
  }

  public override var description: String {
    return "\(super.description), slug: \(slug), tvdb: \(tvdb), tvrage: \(String(describing: tvrage))"
  }
}
