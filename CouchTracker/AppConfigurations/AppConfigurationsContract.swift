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

protocol AppConfigurationsRepository: class {
  var preferredLocales: [Locale] { get }
  var preferredContentLocale: Locale { get set }
  func fetchLoggedUser() -> Observable<User>
}

protocol AppConfigurationsRouter: class {
  func showTraktLogin()
  func showError(message: String)
}

protocol AppConfigurationsInteractor: class {
  init(userRepository: UserRepository)

  func fetchLoginState() -> Observable<LoginState>
}

protocol AppConfigurationsPresenter: class {
  init(view: AppConfigurationsView, interactor: AppConfigurationsInteractor, router: AppConfigurationsRouter)

  func viewDidLoad()
  func optionSelectedAt(index: Int)
}

protocol AppConfigurationsView: class {
  var presenter: AppConfigurationsPresenter! { get set }

  func showConfigurations(models: [AppConfigurationsViewModel])
}
