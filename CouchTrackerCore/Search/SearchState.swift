import TraktSwift

public enum SearchState: Hashable {
  case searching
  case notSearching
  case emptyResults
  case results(entities: [SearchResultEntity])
  case error(error: Error)

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .searching: hasher.combine("SearchState.searching")
    case .notSearching: hasher.combine("SearchState.notSearching")
    case .emptyResults: hasher.combine("SearchState.emptyResults")
    case let .results(viewModels):
      hasher.combine("SearchState.results")
      hasher.combine(viewModels)
    case let .error(error): hasher.combine("SearchState.error-\(error.localizedDescription)")
    }
  }

  public static func == (lhs: SearchState, rhs: SearchState) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
}
