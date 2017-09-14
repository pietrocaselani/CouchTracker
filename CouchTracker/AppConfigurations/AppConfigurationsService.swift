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

final class AppConfigurationsService: AppConfigurationsInteractor {
  private let repository: AppConfigurationsRepository

  init(repository: AppConfigurationsRepository) {
    self.repository = repository
  }

  func traktToken() -> Single<TokenResult> {
    return repository.traktToken().map { token -> TokenResult in
      TokenResult.logged(token: token, user: "trakt username")
      }.catchError { error -> Single<TokenResult> in
        guard let tokenError = error as? TokenError else {
          return Single.error(error)
        }

        return Single.just(TokenResult.error(error: tokenError))
      }.subscribeOn(SerialDispatchQueueScheduler(qos: .background))
  }
}
