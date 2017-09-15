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
import Moya

final class AppConfigurationsMock {
  private init() {}

  static func createUserMock() -> User {
    return try! User(JSON: JSONParser.toObject(data: Users.settings.sampleData))
  }
}

final class AppConfigurationsInteractorMock: AppConfigurationsInteractor {
  private let repository: AppConfigurationsRepository

  init(repository: AppConfigurationsRepository) {
    self.repository = repository
  }

  func fetchLoginState() -> Observable<LoginState> {
    return repository.fetchLoggedUser().map { user -> LoginState in
      LoginState.logged(user: user)
      }.catchError { error in
        guard let moyaError = error as? MoyaError, moyaError.response?.statusCode == 401 else {
          return Observable.error(error)
        }

        return Observable.just(LoginState.notLogged)
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
  private let usersProvider: RxMoyaProvider<Users>
  private let isEmpty: Bool
  init(usersProvider: RxMoyaProvider<Users>, isEmpty: Bool = false) {
    self.usersProvider = usersProvider
    self.isEmpty = isEmpty
    preferredContentLocale = Locale.current
  }

  var preferredContentLocale: Locale

  var preferredLocales: [Locale] {
    return Locale.preferredLanguages.map { Locale(identifier: $0) }
  }

  func fetchLoggedUser() -> Observable<User> {
    guard !isEmpty else { return Observable.empty() }
    return usersProvider.request(.settings).mapObject(Settings.self).map { $0.user }
  }
}

final class AppConfigurationsRepositoryErrorMock: AppConfigurationsRepository {
  private let error: Swift.Error

  init(error: Swift.Error) {
    self.error = error
    preferredContentLocale = Locale.current
  }

  var preferredLocales: [Locale] { return Locale.preferredLanguages.map { Locale(identifier: $0) } }

  var preferredContentLocale: Locale

  func fetchLoggedUser() -> Observable<User> {
    return Observable.error(error)
  }
}
