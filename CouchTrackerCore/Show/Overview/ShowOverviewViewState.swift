public enum ShowOverviewViewState: Hashable {
  case loading
  case showing(show: ShowEntity)
  case error(error: Error)

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .loading: hasher.combine("ShowOverviewViewState.loading")
    case let .showing(show):
      hasher.combine("ShowOverviewViewState.shwoing")
      hasher.combine(show)
    case let .error(error):
      hasher.combine("ShowOverviewViewState.error")
      hasher.combine(error.localizedDescription)
    }
  }

  public static func == (lhs: ShowOverviewViewState, rhs: ShowOverviewViewState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading): return true
    case let (.showing(lhsShow), .showing(rhShow)): return lhsShow == rhShow
    case let (.error(lhsError), .error(rhsError)): return lhsError.localizedDescription == rhsError.localizedDescription
    default: return false
    }
  }
}
