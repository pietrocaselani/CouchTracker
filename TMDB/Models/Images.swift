import ObjectMapper

public final class Images: ImmutableMappable {
  public let identifier: Int
  public let backdrops: [Image]
  public let posters: [Image]
  public let stills: [Image]

  public init(map: Map) throws {
    self.identifier = try map.value("id")
    self.backdrops = (try? map.value("backdrops")) ?? [Image]()
    self.posters = (try? map.value("posters")) ?? [Image]()
    self.stills = (try? map.value("stills")) ?? [Image]()
  }
}
