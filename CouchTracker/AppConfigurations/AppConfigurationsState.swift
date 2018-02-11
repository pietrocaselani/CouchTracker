import TraktSwift

struct AppConfigurationsState: Hashable {
  let loginState: LoginState
  let hideSpecials: Bool

  static func initialState() -> AppConfigurationsState {
    return AppConfigurationsState(loginState: .notLogged, hideSpecials: false)
  }

  func newBuilder() -> AppConfigurationsStateBuilder {
    return AppConfigurationsStateBuilder(state: self)
  }

  var hashValue: Int {
    return loginState.hashValue ^ hideSpecials.hashValue
  }

  static func == (lhs: AppConfigurationsState, rhs: AppConfigurationsState) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

enum LoginState: Hashable {
  case logged(settings: Settings)
  case notLogged

  var hashValue: Int {
    var hash = 11

    if case .logged(let settings) = self {
      hash ^= settings.hashValue
    }

    return hash
  }

  static func == (lhs: LoginState, rhs: LoginState) -> Bool {
    switch (lhs, rhs) {
    case (.logged(let lhsSettings), .logged(let rhsSettings)):
      return lhsSettings == rhsSettings
    case (.notLogged, .notLogged): return true
    default: return false
    }
  }
}

struct AppConfigurationsStateBuilder {
  var loginState = LoginState.notLogged
  var hideSpecials = false

  fileprivate init(state: AppConfigurationsState) {
    self.loginState = state.loginState
    self.hideSpecials = state.hideSpecials
  }

  func build() -> AppConfigurationsState {
    return AppConfigurationsState(loginState: loginState, hideSpecials: hideSpecials)
  }
}
