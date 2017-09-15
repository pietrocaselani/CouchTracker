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

final class AppConfigurationsService: AppConfigurationsInteractor {
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
