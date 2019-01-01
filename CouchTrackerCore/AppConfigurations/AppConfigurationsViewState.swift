public enum AppConfigurationsViewState: Hashable {
  case loading
  case showing(configs: [AppConfigurationsViewModel])

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .loading: hasher.combine("AppConfigurationsViewState.loading")
    case let .showing(configs): hasher.combine(configs)
    }
  }

  public static func == (lhs: AppConfigurationsViewState, rhs: AppConfigurationsViewState) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
