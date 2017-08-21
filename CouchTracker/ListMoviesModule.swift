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

final class ListMoviesModule: ListMoviesRouter {

  func loadView() -> ListMoviesView {
    let viewController = R.storyboard.listMovies().instantiateInitialViewController()

    guard let view = viewController as? ListMoviesViewController else {
      fatalError("viewController should be an instance of ListMoviesViewController")
    }

    let store = ListMoviesStore()

    let interactor = ListMoviesInteractor(store: store)

    let presenter = ListMoviesPresenter(view: view, router: self, interactor: interactor)

    view.presenter = presenter

    return view
  }

}
