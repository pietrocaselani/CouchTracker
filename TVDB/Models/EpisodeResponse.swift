import ObjectMapper

public final class EpisodeResponse: ImmutableMappable {
  public let episode: FullEpisode

  public init(map: Map) throws {
    self.episode = try map.value("data")
  }
}
