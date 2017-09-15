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
import Moya_ObjectMapper
import ObjectMapper
import Moya

final class AppConfigurationsUserDefaultsRepository: AppConfigurationsRepository {
  private static let localeKey = "preferredLocale"
  private static let traktUserKey = "traktUser"
  private let userDefaults: UserDefaults
  private let userProvider: RxMoyaProvider<Users>

  init(userDefaults: UserDefaults, traktProvider: TraktProvider) {
    self.userDefaults = userDefaults
    self.userProvider = traktProvider.users
  }

  var preferredLocales: [Locale] {
    return Locale.preferredLanguages.map { Locale(identifier: $0) }
  }

  var preferredContentLocale: Locale {
    get {
      let localeIdentifier = userDefaults.string(forKey: AppConfigurationsUserDefaultsRepository.localeKey)
      return localeIdentifier.flatMap { Locale(identifier: $0) } ?? Locale.current
    }
    set {
      userDefaults.set(newValue.identifier, forKey: AppConfigurationsUserDefaultsRepository.localeKey)
      userDefaults.synchronize()
    }
  }

  func fetchLoggedUser() -> Observable<User> {
    let apiObservable = fetchSettingsFromAPI()
    let cacheObservable = fetchSettingFromLocalStorage()

    return cacheObservable.catchError { _ in apiObservable }
        .ifEmpty(switchTo: apiObservable)
        .map { $0.user }
  }

  private func fetchSettingFromLocalStorage() -> Observable<Settings> {
    guard let json = self.userDefaults.dictionary(forKey: AppConfigurationsUserDefaultsRepository.traktUserKey) else {
      return Observable.empty()
    }

    let map = Map(mappingType: .fromJSON, JSON: json)
    do {
      let settings = try Settings(map: map)
      return Observable.just(settings)
    } catch {
      return Observable.error(error)
    }
  }

  private func fetchSettingsFromAPI() -> Observable<Settings> {
    return userProvider.request(.settings).mapObject(Settings.self).do(onNext: { [unowned self] settings in
      self.userDefaults.set(settings.toJSON(), forKey: AppConfigurationsUserDefaultsRepository.traktUserKey)
      self.userDefaults.synchronize()
    })
  }
}
