import Foundation

enum ShowProgressDirection: String {
  case asc
  case desc

  func toggle() -> ShowProgressDirection {
    return self == .asc ? .desc : .asc
  }
}

enum ShowProgressSort: String {
  case title
  case remaining
  case lastWatched
  case releaseDate

  static func allValues() -> [ShowProgressSort] {
    return [.title, .remaining, .lastWatched, .releaseDate]
  }

  static func sort(for index: Int) -> ShowProgressSort {
    return ShowProgressSort.allValues()[index]
  }

  func index() -> Int {
    return ShowProgressSort.allValues().index(of: self) ?? 0
  }

  func comparator() -> (WatchedShowEntity, WatchedShowEntity) -> Bool {
    if self == .title { return titleComparator() }
    if self == .remaining { return remainingComparator() }
    if self == .lastWatched { return lastWatchedComparator() }
    return releaseDateComparator()
  }

  private func titleComparator() -> (WatchedShowEntity, WatchedShowEntity) -> Bool {
    return { (lhs: WatchedShowEntity, rhs: WatchedShowEntity) in
      let rhsTitle = rhs.show.title ?? ""
      let lhsTitle = lhs.show.title ?? ""
      return lhsTitle < rhsTitle
    }
  }

  private func remainingComparator() -> (WatchedShowEntity, WatchedShowEntity) -> Bool {
    return { (lhs: WatchedShowEntity, rhs: WatchedShowEntity) in
      let lhsRemaining = lhs.aired - lhs.completed
      let rhsRemaining = rhs.aired - rhs.completed
      return lhsRemaining < rhsRemaining
    }
  }

  private func lastWatchedComparator() -> (WatchedShowEntity, WatchedShowEntity) -> Bool {
    return { (lhs: WatchedShowEntity, rhs: WatchedShowEntity) in
      let lhsLastWatched = lhs.lastWatched ?? Date(timeIntervalSince1970: 0)
      let rhsLastWatched = rhs.lastWatched ?? Date(timeIntervalSince1970: 0)
      return lhsLastWatched > rhsLastWatched
    }
  }

  private func releaseDateComparator() -> (WatchedShowEntity, WatchedShowEntity) -> Bool {
    return { (lhs: WatchedShowEntity, rhs: WatchedShowEntity) in
      let lhsFirstAired = lhs.nextEpisode?.firstAired ?? Date(timeIntervalSince1970: 0)
      let rhsFirstAired = rhs.nextEpisode?.firstAired ?? Date(timeIntervalSince1970: 0)
      return lhsFirstAired > rhsFirstAired
    }
  }
}
