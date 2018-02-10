import TraktSwift

struct WatchedEpisodeEntity: Hashable {
  let showIds: ShowIds
  let number: Int
  let lastWatchedAt: Date?

  var hashValue: Int {
    var hash = showIds.hashValue
    hash ^= number.hashValue

    lastWatchedAt.run { hash ^= $0.hashValue }

    return hash
  }

  static func == (lhs: WatchedEpisodeEntity, rhs: WatchedEpisodeEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
