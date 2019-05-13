public enum MovieDetailsViewState: Hashable {
  case loading
  case showing(movie: MovieEntity)
  case error(error: Error)

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .loading:
      hasher.combine("MovieDetailsViewState.loading")
    case let .showing(movie):
      hasher.combine("MovieDetailsViewState.showing")
      hasher.combine(movie)
    case let .error(error):
      hasher.combine("MovieDetailsViewState.error")
      hasher.combine(error.localizedDescription)
    }
  }

  public static func == (lhs: MovieDetailsViewState, rhs: MovieDetailsViewState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, loading): return true
    case let (.showing(lhsMovie), showing(rhsMovie)): return lhsMovie == rhsMovie
    case let (.error(lhsError), error(rhsError)): return lhsError.localizedDescription == rhsError.localizedDescription
    default: return false
    }
  }
}
