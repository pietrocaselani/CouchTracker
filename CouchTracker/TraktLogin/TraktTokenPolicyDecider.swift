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
import TraktSwift

final class TraktTokenPolicyDecider: TraktLoginPolicyDecider {
  private let trakt: TraktProvider
  private let output: TraktLoginOutput

  init(loginOutput: TraktLoginOutput) {
    fatalError("Not implemented! Use init(loginOutput: traktProvider:)")
  }

  init(loginOutput: TraktLoginOutput, traktProvider: TraktProvider) {
    self.output = loginOutput
    self.trakt = traktProvider
  }

  func allowedToProceed(with request: URLRequest) -> Observable<AuthenticationResult> {
    return trakt.finishesAuthentication(with: request).do(onNext: { [unowned self] result in
      if result == AuthenticationResult.authenticated {
        self.output.loggedInSuccessfully()
      }
    }, onError: { [unowned self] error in
      self.output.logInFail(message: error.localizedDescription)
    })
  }
}
