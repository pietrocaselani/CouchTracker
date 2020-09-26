public final class TrendingShow: BaseTrendingEntity {
  public let show: Show

  private enum CodingKeys: String, CodingKey {
    case show
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    show = try container.decode(Show.self, forKey: .show)

    try super.init(from: decoder)
  }

  public override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(show, forKey: .show)

    try super.encode(to: encoder)
  }

  public override func hash(into hasher: inout Hasher) {
    super.hash(into: &hasher)
    hasher.combine(show)
  }

  public static func == (lhs: TrendingShow, rhs: TrendingShow) -> Bool {
    let lhsTrendingEntity = lhs as BaseTrendingEntity
    let rhsTrendingEntity = rhs as BaseTrendingEntity

    return lhsTrendingEntity == rhsTrendingEntity && lhs.show == rhs.show
  }
}
