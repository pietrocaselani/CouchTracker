import ObjectMapper

public final class Settings: ImmutableMappable {
  public let user: User

  public init(map: Map) throws {
    self.user = try map.value("user")
  }

  public func mapping(map: Map) {
    user >>> map["user"]
  }
}
