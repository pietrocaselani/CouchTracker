import TraktSwift

public struct AppConfigurationsState: Hashable {
  public let loginState: LoginState
  public let hideSpecials: Bool

  public init(loginState: LoginState, hideSpecials: Bool) {
    self.loginState = loginState
    self.hideSpecials = hideSpecials
  }

  public static func initialState() -> AppConfigurationsState {
    return AppConfigurationsState(loginState: .notLogged, hideSpecials: false)
  }

  public func newBuilder() -> AppConfigurationsStateBuilder {
    return AppConfigurationsStateBuilder(state: self)
  }

  public var hashValue: Int {
    return loginState.hashValue ^ hideSpecials.hashValue
  }

  public static func == (lhs: AppConfigurationsState, rhs: AppConfigurationsState) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

public enum LoginState: Hashable {
  case logged(settings: Settings)
  case notLogged

  public var hashValue: Int {
    var hash = 11

    if case let .logged(settings) = self {
      hash ^= settings.hashValue
    }

    return hash
  }

  public static func == (lhs: LoginState, rhs: LoginState) -> Bool {
    switch (lhs, rhs) {
    case let (.logged(lhsSettings), .logged(rhsSettings)):
      return lhsSettings == rhsSettings
    case (.notLogged, .notLogged): return true
    default: return false
    }
  }
}

public struct AppConfigurationsStateBuilder {
  public var loginState = LoginState.notLogged
  public var hideSpecials = false

  fileprivate init(state: AppConfigurationsState) {
    loginState = state.loginState
    hideSpecials = state.hideSpecials
  }

  public func build() -> AppConfigurationsState {
    return AppConfigurationsState(loginState: loginState, hideSpecials: hideSpecials)
  }
}
