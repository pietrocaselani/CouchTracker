import ObjectMapper

public final class Images: ImmutableMappable, Hashable {
  public let avatar: ImageSizes

  public init(map: Map) throws {
    self.avatar = try map.value("avatar")
  }

  public func mapping(map: Map) {
    avatar >>> map["avatar"]
  }

  public var hashValue: Int {
    return avatar.hashValue
  }

  public static func ==(lhs: Images, rhs: Images) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
