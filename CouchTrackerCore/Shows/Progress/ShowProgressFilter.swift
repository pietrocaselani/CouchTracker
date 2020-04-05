import TraktSwift

public enum ShowProgressFilter: String {
  case none
  case watched
  case returning
  case returningWatched

  public static func create(from value: String?) -> ShowProgressFilter {
    guard let stringValue = value else { return ShowProgressFilter.none }
    return ShowProgressFilter(rawValue: stringValue) ?? ShowProgressFilter.none
  }

  public static func allValues() -> [ShowProgressFilter] {
    [.none, .watched, .returning, returningWatched]
  }

  public static func filter(for index: Int) -> ShowProgressFilter {
    let allValues = ShowProgressFilter.allValues()
    if index < 0 || index >= allValues.count {
      return ShowProgressFilter.none
    }

    return allValues[index]
  }

  public func index() -> Int {
    ShowProgressFilter.allValues().firstIndex(of: self) ?? 0
  }

  public func filter() -> (WatchedShowEntity) -> Bool {
    switch self {
    case .none: return filterNone(_:)
    case .watched: return filterWatched(_:)
    case .returning: return filterReturning(_:)
    case .returningWatched: return filterReturningWatched(_:)
    }
  }
}

private func filterNone(_ entity: WatchedShowEntity) -> Bool {
  true
}

private func filterWatched(_ entity: WatchedShowEntity) -> Bool {
  (entity.aired ?? -1) - (entity.completed ?? -1) > 0
}

private func filterReturning(_ entity: WatchedShowEntity) -> Bool {
  entity.show.status == .returning
}

private func filterReturningWatched(_ entity: WatchedShowEntity) -> Bool {
  filterWatched(entity) || filterReturning(entity)
}
