import TraktSwift

public struct AppState: Hashable, Codable {
  public let userSettings: Settings?
  public let hideSpecials: Bool

  public var isLogged: Bool {
    return userSettings != nil
  }

  public init(userSettings: Settings?, hideSpecials: Bool) {
    self.userSettings = userSettings
    self.hideSpecials = hideSpecials
  }

  public static func initialState() -> AppState {
    return Defaults.appState
  }

  public func newBuilder() -> AppStateBuilder {
    return AppStateBuilder(state: self)
  }

  public func buildUpon(_ builderFn: (inout AppStateBuilder) -> Void) -> AppState {
    var builder = newBuilder()
    builderFn(&builder)
    return builder.build()
  }
}

public struct AppStateBuilder {
  public var userSettings: Settings?
  public var hideSpecials = false

  fileprivate init(state: AppState) {
    userSettings = state.userSettings
    hideSpecials = state.hideSpecials
  }

  public func build() -> AppState {
    return AppState(userSettings: userSettings, hideSpecials: hideSpecials)
  }
}
