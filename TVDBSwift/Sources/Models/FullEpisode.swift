public final class FullEpisode: Codable {
  public let filename: String?

  private enum CodingKeys: String, CodingKey {
    case filename
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    filename = try container.decodeIfPresent(String.self, forKey: .filename)
  }
}
