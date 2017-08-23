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

final class TraktListMoviesModule: ListMoviesRouter {

  private let trakt: TraktV2
  private var detailsRouter: MovieDetailsRouter?

  init(trakt: TraktV2) {
    self.trakt = trakt
  }

  func loadView() -> BaseView {
    guard let navigationController =
      R.storyboard.listMovies().instantiateInitialViewController() as? UINavigationController else {
      fatalError("viewController should be an instance of UINavigationController")
    }

    guard let view = navigationController.topViewController as? ListMoviesView else {
      fatalError("topViewController should be an instance of ListMoviesView")
    }

    let store = ListMoviesStore(trakt: trakt)

    let interactor = ListMoviesInteractor(store: store)

    let presenter = ListMoviesPresenter(view: view, router: self, interactor: interactor)

    view.presenter = presenter

    return navigationController
  }

  func showDetails(of movie: TrendingMovie, navigable: Navigable) {
    let detailsModule = MovieDetailsModule(trakt: trakt)
    let detailsView = detailsModule.loadView(of: movie.movie.ids.slug)

    detailsRouter = detailsModule

    navigable.push(view: detailsView, animated: true)
  }

}
