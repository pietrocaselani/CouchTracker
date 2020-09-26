public class BaseTrendingEntity: Codable, Hashable {
  public let watchers: Int

  public func hash(into hasher: inout Hasher) {
    hasher.combine(watchers)
  }

  public static func == (lhs: BaseTrendingEntity, rhs: BaseTrendingEntity) -> Bool {
    lhs.watchers == rhs.watchers
  }
}
