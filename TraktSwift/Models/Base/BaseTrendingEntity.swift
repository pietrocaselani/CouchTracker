public class BaseTrendingEntity: Codable, Hashable {
  public let watchers: Int

  public var hashValue: Int {
    return watchers.hashValue
  }

  public static func == (lhs: BaseTrendingEntity, rhs: BaseTrendingEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
