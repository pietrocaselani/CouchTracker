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

final class AppConfigurationsMock {
  private init() {}

  static func createTraktTokenMock() -> Token {
    let date = Date(timeIntervalSince1970: 5)
    return Token(accessToken: "accessToken1", expiresIn: date,
                 refreshToken: "refresh1", tokenType: "type1", scope: "general")
  }
}

final class AppConfigurationsInteractorMock: AppConfigurationsInteractor {
  private let repository: AppConfigurationsRepository
  init(repository: AppConfigurationsRepository) {
    self.repository = repository
  }

  func traktToken() -> Single<TokenResult> {
    return repository.traktToken().map { TokenResult.logged(token: $0, user: "trakt username") }
      .catchError { error -> Single<TokenResult> in
        guard let tokenError = error as? TokenError else {
          return Single.error(error)
        }

        return Single.just(TokenResult.error(error: tokenError))
    }
  }
}

final class AppConfigurationsViewMock: AppConfigurationsView {
  var presenter: AppConfigurationsPresenter!
  var invokedShowConfigurations = false
  var invokedShowConfigurationsParameters: (models: [AppConfigurationsViewModel], Void)?

  func showConfigurations(models: [AppConfigurationsViewModel]) {
    invokedShowConfigurations = true
    invokedShowConfigurationsParameters = (models, ())
  }
}

final class AppConfigurationsRouterMock: AppConfigurationsRouter {
  var invokedShowTraktLogin = false
  var invokedShowErrorMessage = false
  var invokedShowErrorMessageParameters: (message: String, Void)?

  func showTraktLogin() {
    invokedShowTraktLogin = true
  }

  func showError(message: String) {
    invokedShowErrorMessage = true
    invokedShowErrorMessageParameters = (message, ())
  }
}

final class AppConfigurationsRepositoryMock: AppConfigurationsRepository {
  var appLocale: Locale
  var appToken: Token?

  init() {
    appLocale = Locale.current
  }

  func availableLocales() -> Single<[Locale]> {
    return Single.just(Locale.preferredLanguages.map { Locale(identifier: $0) })
  }

  func updatePreferredContent(locale: Locale) -> Completable {
    appLocale = locale
    return Completable.empty()
  }

  func preferredContentLocale() -> Single<Locale> {
    return Single.just(appLocale)
  }

  func updateTrakt(token: Token) -> Completable {
    appToken = token
    return Completable.empty()
  }

  func traktToken() -> Single<Token> {
    guard let token = appToken else { return Single.error(TokenError.absent) }
    return Single.just(token)
  }
}

final class AppConfigurationsRepositoryErrorMock: AppConfigurationsRepository {
  private let error: Error

  init(error: Error) {
    self.error = error
  }

  func availableLocales() -> Single<[Locale]> {
    return Single.error(error)
  }

  func updatePreferredContent(locale: Locale) -> Completable {
    return Completable.error(error)
  }

  func preferredContentLocale() -> Single<Locale> {
    return Single.error(error)
  }

  func updateTrakt(token: Token) -> Completable {
    return Completable.error(error)
  }

  func traktToken() -> Single<Token> {
    return Single.error(error)
  }
}
