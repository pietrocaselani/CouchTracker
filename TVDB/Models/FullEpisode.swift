import ObjectMapper

public final class FullEpisode: ImmutableMappable {
  public let filename: String?

  public init(map: Map) throws {
    self.filename = try? map.value("filename")
  }
}
