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
    let store = MovieDetailsStore(apiProvider: apiProvider)
    let genreStore = TraktGenreStore(apiProvider: apiProvider)
    let interactor = MovieDetailsInteractor(store: store, genreStore: genreStore)

    let viewController = R.storyboard.movieDetails.movieDetailsViewController()

    guard let view = viewController else {
      fatalError("viewController should be an instance of MovieDetailsView")
    }

    let presenter = MovieDetailsPresenter(view: view, interactor: interactor, movieId: movieId)

    view.presenter = presenter

    return view
  }
}
