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

  static func setupModule(traktProvider: TraktProvider, tmdbProvider: TMDBProvider) -> BaseView {
    guard let navigationController =
    R.storyboard.listMovies().instantiateInitialViewController() as? UINavigationController else {
      fatalError("viewController should be an instance of UINavigationController")
    }

    guard let view = navigationController.topViewController as? ListMoviesView else {
      fatalError("topViewController should be an instance of ListMoviesView")
    }

    guard let viewController = view as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    let repository = ListMoviesCacheRepository(traktProvider: traktProvider)
    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdbProvider)
    let movieImageRepository = MovieImageCachedRepository(tmdbProvider: tmdbProvider,
                                                          cofigurationRepository: configurationRepository)

    let interactor = ListMoviesService(repository: repository, movieImageRepository: movieImageRepository)
    let router = ListMoviesiOSRouter(viewController: viewController, traktProvider: traktProvider)
    let presenter = ListMoviesiOSPresenter(view: view, interactor: interactor, router: router)

    let searchOutput = ListMoviesSearchOutput(view: view, router: router, presenter: presenter)

    view.presenter = presenter

    view.searchView = SearchModule.setupModule(traktProvider: traktProvider, resultsOutput: searchOutput)

    return navigationController
  }
}
