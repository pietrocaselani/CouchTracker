import NonEmpty

public struct ShowsProgressMenuOptions: Hashable {
  public let sort: [ShowProgressSort]
  public let filter: [ShowProgressFilter]
  public let currentFilter: ShowProgressFilter
  public let currentSort: ShowProgressSort
}

public enum ShowProgressViewState: Hashable {
  case notLogged
  case loading
  case empty
  case shows(entities: NonEmptyArray<WatchedShowEntity>, menu: ShowsProgressMenuOptions)
  case filterEmpty
  case error(error: Error)

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .notLogged: hasher.combine("ShowProgressViewState.notLogged")
    case .loading: hasher.combine("ShowProgressViewState.loading")
    case .empty: hasher.combine("ShowProgressViewState.empty")
    case .filterEmpty: hasher.combine("ShowProgressViewState.filterEmpty")
    case let .shows(entities, menu):
      hasher.combine("ShowProgressViewState.shows")
      hasher.combine(entities)
      hasher.combine(menu)
    case let .error(error):
      hasher.combine("ShowProgressViewState.error")
      hasher.combine(error.localizedDescription)
    }
  }

  public static func == (lhs: ShowProgressViewState, rhs: ShowProgressViewState) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
