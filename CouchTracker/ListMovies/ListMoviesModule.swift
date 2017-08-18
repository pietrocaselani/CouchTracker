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

  private let trakt: TraktV2

  init(trakt: TraktV2) {
    self.trakt = trakt
  }

  func configure(view: ListMoviesView) {
    let store = ListMoviesStoreImpl(trakt: trakt)

    let interactor = ListMoviesInteractorImpl(store: store)

    let presenter = ListMoviesPresenterImpl(view: view, router: self, interactor: interactor)

    view.presenter = presenter
  }

}
