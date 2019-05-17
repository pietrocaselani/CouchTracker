public final class Images: Codable {
  public let identifier: Int
  public let backdrops: [Image]
  public let posters: [Image]
  public let stills: [Image]

  private enum CodingKeys: String, CodingKey {
    case identifier = "id"
    case backdrops, posters, stills
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    identifier = try container.decode(Int.self, forKey: .identifier)
    backdrops = try container.decodeIfPresent([Image].self, forKey: .backdrops) ?? [Image]()
    posters = try container.decodeIfPresent([Image].self, forKey: .posters) ?? [Image]()
    stills = try container.decodeIfPresent([Image].self, forKey: .stills) ?? [Image]()
  }
}
