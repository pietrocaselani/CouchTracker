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

final class AppConfigurationsUserDefaultsRepository: AppConfigurationsRepository {
  private static let localeKey = "preferredLocale"
  private static let traktTokenKey = "traktToken"
  private let userDefaults: UserDefaults

  init(userDefaults: UserDefaults) {
    self.userDefaults = userDefaults
  }

  var preferredContentLocale: Locale {
    get {
      let localeIdentifier = userDefaults.string(forKey: AppConfigurationsUserDefaultsRepository.localeKey)
      return localeIdentifier.flatMap { Locale(identifier: $0) } ?? Locale.current
    }
    set {
      userDefaults.set(newValue.identifier, forKey: AppConfigurationsUserDefaultsRepository.localeKey)
    }
  }

  var traktToken: Token? {
    get {
      let data = userDefaults.data(forKey: AppConfigurationsUserDefaultsRepository.traktTokenKey)

      guard let tokenData = data, let token = NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? Token else {
        return nil
      }

      return token
    }
    set {
      if let newToken = newValue {
        let tokenData = NSKeyedArchiver.archivedData(withRootObject: newToken)
        userDefaults.set(tokenData, forKey: AppConfigurationsUserDefaultsRepository.traktTokenKey)
      } else {
        userDefaults.removeObject(forKey: AppConfigurationsUserDefaultsRepository.traktTokenKey)
      }
    }
  }
}
