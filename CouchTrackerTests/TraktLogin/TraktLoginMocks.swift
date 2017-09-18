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

final class TraktLoginOutputMock: TraktLoginOutput {
  var invokedLoggedInSuccessfully = false
  var invokedLogInFail = false
  var invokedLoginFailParameters: (message: String, Void)?

  func loggedInSuccessfully() {
    invokedLoggedInSuccessfully = true
  }

  func logInFail(message: String) {
    invokedLogInFail = true
    invokedLoginFailParameters = (message, ())
  }
}

final class TraktLoginErrorInteractorMock: TraktLoginInteractor {
  private let error: Error
  init(traktProvider: TraktProvider = TraktProviderMock(), error: Error) {
    self.error = error
  }

  init(traktProvider: TraktProvider) {
    fatalError("Please, use init(traktProvider: error:)")
  }

  func fetchLoginURL() -> Single<URL> {
    return Single.error(error)
  }
}

final class TraktLoginInteractorMock: TraktLoginInteractor {
  private let url: URL

  init(traktProvider: TraktProvider) {
    guard let oauthURL = traktProvider.oauthURL else {
      fatalError("Impossible to create oauthURL without a redirect URL.")
    }

    self.url = oauthURL
  }

  func fetchLoginURL() -> Single<URL> {
    return Single.just(url)
  }
}

final class TraktLoginViewMock: TraktLoginView {
  var presenter: TraktLoginPresenter!

  var invokedLoadLogin = false
  var invokedLoadLoginParameters: (url: URL, Void)?

  func loadLogin(using url: URL) {
    invokedLoadLogin = true
    invokedLoadLoginParameters = (url, ())
  }
}
