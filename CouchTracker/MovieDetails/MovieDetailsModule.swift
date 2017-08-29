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

final class MovieDetailsModule {

  private init() {}

  static func setupModule(apiProvider: APIProvider, movieId: String) -> BaseView {
    let repository = MovieDetailsCacheRepository(apiProvider: apiProvider)
    let genreRepository = TraktGenreRepository(apiProvider: apiProvider)
    let interactor = MovieDetailsUseCase(repository: repository, genreRepository: genreRepository, movieId: movieId)

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
