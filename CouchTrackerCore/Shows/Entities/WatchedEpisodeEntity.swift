import TraktSwift

public struct WatchedEpisodeEntity: Hashable {
  public let showIds: ShowIds
  public let number: Int
  public let lastWatchedAt: Date?

  public var hashValue: Int {
    var hash = showIds.hashValue
    hash ^= number.hashValue

    lastWatchedAt.run { hash ^= $0.hashValue }

    return hash
  }

  public static func == (lhs: WatchedEpisodeEntity, rhs: WatchedEpisodeEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
