import TraktSwift

struct WatchedSeasonEntity: Hashable {
  let showIds: ShowIds
  let number: Int
  let aired: Int?
  let completed: Int?
  let episodes: [WatchedEpisodeEntity]

  var hashValue: Int {
    var hash = showIds.hashValue
    hash ^= number.hashValue
    aired.run { hash ^= $0.hashValue }
    completed.run { hash ^= $0.hashValue }

    episodes.forEach { hash ^= $0.hashValue }

    return hash
  }

  static func == (lhs: WatchedSeasonEntity, rhs: WatchedSeasonEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
