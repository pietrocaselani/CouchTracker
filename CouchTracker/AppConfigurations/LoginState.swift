import Trakt

enum LoginState: Equatable {
  case logged(user: User)
  case notLogged

  static func == (lhs: LoginState, rhs: LoginState) -> Bool {
    switch (lhs, rhs) {
    case (.logged(let lhsUser), .logged(let rhsUser)):
      return lhsUser == rhsUser
    case (.notLogged, .notLogged): return true
    default: return false
    }
  }
}
