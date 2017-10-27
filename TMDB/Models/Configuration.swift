import ObjectMapper

public final class Configuration: ImmutableMappable {

  public let images: ImagesConfiguration

  public init(map: Map) throws {
    self.images = try map.value("images")
  }
}
