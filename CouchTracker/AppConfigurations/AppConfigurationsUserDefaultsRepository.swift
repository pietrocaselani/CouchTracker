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

import Foundation
import TraktSwift
import RxSwift

final class AppConfigurationsUserDefaultsRepository: AppConfigurationsRepository {
  private static let localeKey = "preferredLocale"
  private static let traktTokenKey = "traktToken"
  private let userDefaults: UserDefaults

  init(userDefaults: UserDefaults) {
    self.userDefaults = userDefaults
  }

  deinit {
    print(#file, #function)
  }

  func updatePreferredContent(locale: Locale) -> Completable {
    return Completable.create { [unowned self] completable -> Disposable in
      self.userDefaults.set(locale.identifier, forKey: AppConfigurationsUserDefaultsRepository.localeKey)
      completable(.completed)
      return Disposables.create()
    }
  }

  func preferredContentLocale() -> Single<Locale> {
    return Single.create(subscribe: { [unowned self] single -> Disposable in
      let localeIdentifier = self.userDefaults.string(forKey: AppConfigurationsUserDefaultsRepository.localeKey)
      let locale = localeIdentifier.flatMap { Locale(identifier: $0) } ?? Locale.current

      single(.success(locale))

      return Disposables.create()
    })
  }

  func updateTrakt(token: Token) -> Completable {
    return Completable.create(subscribe: { [unowned self] completable -> Disposable in
      let tokenData = NSKeyedArchiver.archivedData(withRootObject: token)
      self.userDefaults.set(tokenData, forKey: AppConfigurationsUserDefaultsRepository.traktTokenKey)

      completable(.completed)

      return Disposables.create()
    })
  }

  func traktToken() -> Single<Token> {
    return Single.create(subscribe: { [unowned self] single -> Disposable in
      let data = self.userDefaults.data(forKey: AppConfigurationsUserDefaultsRepository.traktTokenKey)

      if let tokenData = data, let token = NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? Token {
        single(.success(token))
      } else {
        single(.error(TokenError.absent))
      }

      return Disposables.create()
    })
  }
}
