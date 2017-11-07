import RxSwift

final class TraktLoginStore: TraktLoginOutputProvider, TraktLoginObservable {
  var loginOutput: TraktLoginOutput

  init(trakt: TraktAuthenticationProvider) {
    let initialState = trakt.isAuthenticated ? TraktLoginState.logged : TraktLoginState.notLogged
    let loginState = BehaviorSubject(value: initialState)
    self.loginOutput = TraktLoginStoreOutput(loginState)
  }

  func observe() -> Observable<TraktLoginState> {
    guard let output = loginOutput as? TraktLoginStoreOutput else { fatalError("This can never happen.") }
    return output.loginState.asObservable()
  }
}

fileprivate final class TraktLoginStoreOutput: TraktLoginOutput {
  fileprivate let loginState: BehaviorSubject<TraktLoginState>

  fileprivate init(_ loginState: BehaviorSubject<TraktLoginState>) {
    self.loginState = loginState
  }

  func loggedInSuccessfully() {
    loginState.onNext(.logged)
  }

  func logInFail(message: String) {
    loginState.onNext(.notLogged)
  }
}
