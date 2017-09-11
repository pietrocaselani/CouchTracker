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

import Trakt_Swift

final class ShowDetailsModule {
  private init() {}

  static func setupModule(traktProvider: TraktProvider, showIds: ShowIds) -> BaseView {
    let repository = ShowDetailsCacheRepository(traktProvider: traktProvider)
    let genreRepository = TraktGenreRepository(traktProvider: traktProvider)

    let interactor = ShowDetailsService(showId: showIds.slug, repository: repository, genreRepository: genreRepository)

    guard let view = R.storyboard.showDetails.showDetailsViewController() else {
      fatalError("view should be an instance of ShowDetailsViewController")
    }

    let router = ShowDetailsiOSRouter(viewController: view)

    let presenter = ShowDetailsiOSPresenter(view: view, router: router, interactor: interactor)

    view.presenter = presenter

    return view
  }
}
