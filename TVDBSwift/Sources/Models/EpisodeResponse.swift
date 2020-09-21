public final class EpisodeResponse: Codable {
  public let episode: FullEpisode

  private enum CodingKeys: String, CodingKey {
    case episode = "data"
  }

  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    episode = try container.decode(FullEpisode.self, forKey: .episode)
  }
}
