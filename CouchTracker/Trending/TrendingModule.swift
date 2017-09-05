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

final class TrendingModule {

  private init() {}

  static func setupModule(traktProvider: TraktProvider, tmdbProvider: TMDBProvider) -> BaseView {
    guard let navigationController =
    R.storyboard.trending().instantiateInitialViewController() as? UINavigationController else {
      fatalError("viewController should be an instance of UINavigationController")
    }

    guard let view = navigationController.topViewController as? TrendingView else {
      fatalError("topViewController should be an instance of TrendingView")
    }

    guard let viewController = view as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    let repository = TrendingCacheRepository(traktProvider: traktProvider)
    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdbProvider)
    let imageRepository = ImageCachedRepository(tmdbProvider: tmdbProvider,
                                                          cofigurationRepository: configurationRepository)

    let interactor = TrendingService(repository: repository, imageRepository: imageRepository)
    let router = TrendingiOSRouter(viewController: viewController, traktProvider: traktProvider,
                                     tmdbProvider: tmdbProvider)
    let presenter = TrendingiOSPresenter(view: view, interactor: interactor, router: router)

    let searchOutput = TrendingSearchOutput(view: view, router: router, presenter: presenter)

    view.presenter = presenter

    view.searchView = SearchModule.setupModule(traktProvider: traktProvider, resultsOutput: searchOutput)

    return navigationController
  }
}
