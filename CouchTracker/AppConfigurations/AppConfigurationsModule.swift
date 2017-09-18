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

import UIKit

final class AppConfigurationsModule {
  private init() {}

  static func setupModule(traktProvider: TraktProvider) -> BaseView {
    guard let navigationController = R.storyboard.appConfigurations.instantiateInitialViewController() else {
      fatalError("Impossible to instantiate initial view controller from AppConfigurations storyboard")
    }

    guard let view = navigationController.topViewController as? AppConfigurationsViewController else {
      fatalError("topViewController should be an instance of AppConfigurationsViewController")
    }

    let userDefaults = UserDefaults.standard
    let repository = AppConfigurationsUserDefaultsRepository(userDefaults: userDefaults, traktProvider: traktProvider)
    let interactor = AppConfigurationsService(repository: repository)
    let router = AppConfigurationsiOSRouter(viewController: view, traktProvider: traktProvider)
    let presenter = AppConfigurationsiOSPresenter(view: view, interactor: interactor, router: router)

    view.presenter = presenter

    return navigationController
  }
}
