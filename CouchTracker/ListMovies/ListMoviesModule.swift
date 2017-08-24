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

final class ListMoviesModule {

  private init() {}

  static func setupModule(apiProvider: APIProvider) -> BaseView {
    guard let navigationController =
    R.storyboard.listMovies().instantiateInitialViewController() as? UINavigationController else {
      fatalError("viewController should be an instance of UINavigationController")
    }

    guard let view = navigationController.topViewController as? ListMoviesView else {
      fatalError("topViewController should be an instance of ListMoviesView")
    }

    let store = ListMoviesStore(apiProvider: apiProvider)
    let interactor = ListMoviesInteractor(store: store)
    let router = ListMoviesiOSRouter(navigationController: navigationController, apiProvider: apiProvider)
    let presenter = ListMoviesPresenter(view: view, interactor: interactor, router: router)

    view.presenter = presenter

    return navigationController
  }
}
