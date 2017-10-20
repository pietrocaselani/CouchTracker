import ObjectMapper

public class BaseTrendingEntity: ImmutableMappable, Hashable {
  public let watchers: Int

  public required init(map: Map) throws {
    self.watchers = try map.value("watchers")
  }

  public var hashValue: Int {
    return watchers.hashValue
  }

  public static func == (lhs: BaseTrendingEntity, rhs: BaseTrendingEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
