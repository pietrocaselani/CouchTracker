import TraktSwift

public enum SearchResultState: Hashable {
  case emptyResults
  case results(results: [SearchResult])
}

public enum SearchState: Hashable {
  case searching
  case notSearching
  case error(error: Error)

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .searching: hasher.combine("SearchState.searching")
    case .notSearching: hasher.combine("SearchState.notSearching")
    case let .error(error): hasher.combine("SearchState.error-\(error.localizedDescription)")
    }
  }

  public static func == (lhs: SearchState, rhs: SearchState) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
