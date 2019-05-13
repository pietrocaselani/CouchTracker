public enum SyncMovieResult: Hashable {
  case success
  case fail(error: Error)

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .success: hasher.combine("SyncMovieResult.success")
    case let .fail(error):
      hasher.combine("SyncMovieResult.fail")
      hasher.combine(error.localizedDescription)
    }
  }

  public static func == (lhs: SyncMovieResult, rhs: SyncMovieResult) -> Bool {
    switch (lhs, rhs) {
    case (.success, .success): return true
    case let (.fail(lhsError), .fail(rhsError)): return lhsError.localizedDescription == rhsError.localizedDescription
    default: return false
    }
  }
}
