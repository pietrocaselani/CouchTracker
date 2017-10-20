import ObjectMapper

public final class UserIds: ImmutableMappable, Hashable {
  public let slug: String

  public init(map: Map) throws {
    self.slug = try map.value("slug")
  }

  public func mapping(map: Map) {
    slug >>> map["slug"]
  }

  public var hashValue: Int {
    return slug.hashValue
  }

  public static func == (lhs: UserIds, rhs: UserIds) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
