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

import TraktSwift

final class ShowDetailsModule {
  private init() {}

  static func setupModule(showIds: ShowIds) -> BaseView {
    let trakt = Environment.instance.trakt
    let tmdb = Environment.instance.tmdb
    let tvdb = Environment.instance.tvdb
    let cache = Environment.instance.diskCache

    let repository = ShowDetailsCacheRepository(traktProvider: trakt)
    let genreRepository = TraktGenreRepository(traktProvider: trakt)
    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                tvdb: tvdb,
                                                cofigurationRepository: configurationRepository,
                                                cache: cache)

    let interactor = ShowDetailsService(showIds: showIds, repository: repository,
                                        genreRepository: genreRepository, imageRepository: imageRepository)

    guard let view = R.storyboard.showDetails.showDetailsViewController() else {
      fatalError("view should be an instance of ShowDetailsViewController")
    }

    let router = ShowDetailsiOSRouter(viewController: view)

    let presenter = ShowDetailsiOSPresenter(view: view, router: router, interactor: interactor)

    view.presenter = presenter

    return view
  }
}
