import Foundation

public enum ShowProgressDirection: String {
  case asc
  case desc

  public static func create(from value: String?) -> ShowProgressDirection {
    guard let stringValue = value else { return ShowProgressDirection.asc }
    return ShowProgressDirection(rawValue: stringValue) ?? ShowProgressDirection.asc
  }

  public func toggle() -> ShowProgressDirection {
    self == .asc ? .desc : .asc
  }
}

public enum ShowProgressSort: String {
  case title
  case remaining
  case lastWatched
  case releaseDate

  public static func create(from value: String?) -> ShowProgressSort {
    guard let stringValue = value else { return ShowProgressSort.title }
    return ShowProgressSort(rawValue: stringValue) ?? ShowProgressSort.title
  }

  public static func allValues() -> [ShowProgressSort] {
    [.title, .remaining, .lastWatched, .releaseDate]
  }

  public static func sort(for index: Int) -> ShowProgressSort {
    let allValues = ShowProgressSort.allValues()
    if index < 0 || index >= allValues.count {
      return ShowProgressSort.title
    }

    return allValues[index]
  }

  public func index() -> Int {
    ShowProgressSort.allValues().firstIndex(of: self) ?? 0
  }

  public func comparator() -> (WatchedShowEntity, WatchedShowEntity) -> Bool {
    switch self {
    case .title: return titleComparator(lhs:rhs:)
    case .remaining: return remainingComparator(lhs:rhs:)
    case .lastWatched: return lastWatchedComparator(lhs:rhs:)
    case .releaseDate: return releaseDateComparator(lhs:rhs:)
    }
  }
}

private func titleComparator(lhs: WatchedShowEntity, rhs: WatchedShowEntity) -> Bool {
  let rhsTitle = rhs.show.title ?? ""
  let lhsTitle = lhs.show.title ?? ""
  return lhsTitle < rhsTitle
}

private func remainingComparator(lhs: WatchedShowEntity, rhs: WatchedShowEntity) -> Bool {
  let lhsRemaining = (lhs.aired ?? 0) - (lhs.completed ?? 0)
  let rhsRemaining = (rhs.aired ?? 0) - (rhs.completed ?? 0)
  return lhsRemaining < rhsRemaining
}

private func lastWatchedComparator(lhs: WatchedShowEntity, rhs: WatchedShowEntity) -> Bool {
  let lhsLastWatched = lhs.lastWatched ?? Date(timeIntervalSince1970: 0)
  let rhsLastWatched = rhs.lastWatched ?? Date(timeIntervalSince1970: 0)
  return lhsLastWatched > rhsLastWatched
}

private func releaseDateComparator(lhs: WatchedShowEntity, rhs: WatchedShowEntity) -> Bool {
  let lhsFirstAired = lhs.nextEpisode?.episode.firstAired ?? Date(timeIntervalSince1970: 0)
  let rhsFirstAired = rhs.nextEpisode?.episode.firstAired ?? Date(timeIntervalSince1970: 0)
  return lhsFirstAired > rhsFirstAired
}
