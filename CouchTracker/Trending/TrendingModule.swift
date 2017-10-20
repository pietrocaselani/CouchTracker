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

  static func setupModule() -> BaseView {
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

    let traktProvider = Environment.instance.trakt
    let tmdb = Environment.instance.tmdb
    let tvdb = Environment.instance.tvdb
    let diskCache = Environment.instance.diskCache

    let repository = TrendingCacheRepository(traktProvider: traktProvider)
    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                cache: diskCache)

    let interactor = TrendingService(repository: repository, imageRepository: imageRepository)
    let router = TrendingiOSRouter(viewController: viewController)

    let dataSource = TrendingCollectionViewDataSource(imageRepository: imageRepository)

    let presenter = TrendingiOSPresenter(view: view, interactor: interactor, router: router, dataSource: dataSource)

    view.presenter = presenter
    view.appConfigurationsPresentable = presenter

    view.searchView = SearchModule.setupModule(traktProvider: traktProvider, resultsOutput: presenter)

    return navigationController
  }
}
