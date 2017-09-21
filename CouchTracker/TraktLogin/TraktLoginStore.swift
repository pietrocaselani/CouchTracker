/*
 Copyright 2017 ArcTouch LLC.
 All rights reserved.
 
 This file, its contents, concepts, methods, behavior, and operation
 (collectively the "Software") are protected by trade secret, patent,
 and copyright laws. The use of the Software is governed by a license
 agreement. Disclosure of the Software to third parties, in any form,
 in whole or in part, is expressly prohibited except as authorized by
 the license agreement.
 */

import RxSwift

final class TraktLoginStore: TraktLoginOutputProvider, TraktLoginObservable {
  var loginOutput: TraktLoginOutput

  init(trakt: TraktProvider) {
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
