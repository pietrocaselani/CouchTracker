public enum AppStateViewState: Hashable {
  case loading
  case showing(configs: [AppStateViewModel])

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .loading: hasher.combine("AppStateViewState.loading")
    case let .showing(configs): hasher.combine(configs)
    }
  }

  public static func == (lhs: AppStateViewState, rhs: AppStateViewState) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
