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

final class MovieDetailsModule {
  private init() {}

  static func setupModule(movieIds: MovieIds) -> BaseView {
    let trakt = Environment.instance.trakt
    let tmdb = Environment.instance.tmdb
    let tvdb = Environment.instance.tvdb
    let cache = Environment.instance.diskCache

    let repository = MovieDetailsCacheRepository(traktProvider: trakt)
    let genreRepository = TraktGenreRepository(traktProvider: trakt)
    let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
    let imageRespository = ImageCachedRepository(tmdb: tmdb,
                                                 tvdb: tvdb,
                                                 cofigurationRepository: configurationRepository,
                                                 cache: cache)
    let interactor = MovieDetailsService(repository: repository, genreRepository: genreRepository,
                                         imageRepository: imageRespository, movieIds: movieIds)

    let viewController = R.storyboard.movieDetails.movieDetailsViewController()

    guard let view = viewController else {
      fatalError("viewController should be an instance of MovieDetailsView")
    }

    let router = MovieDetailsiOSRouter(viewController: view)

    let presenter = MovieDetailsiOSPresenter(view: view, interactor: interactor, router: router)

    view.presenter = presenter

    return view
  }
}
