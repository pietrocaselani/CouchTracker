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

final class MovieDetailsModule: MovieDetailsRouter {

  private let trakt: TraktV2

  init(trakt: TraktV2) {
    self.trakt = trakt
  }

  func loadView(of movieId: String) -> BaseView {
    let store = MovieDetailsStore(trakt: trakt)
    let interactor = MovieDetailsInteractor(store: store)

    let viewController = R.storyboard.movieDetails.movieDetailsViewController()

    guard let view = viewController else {
      fatalError("viewController should be an instance of MovieDetailsView")
    }

    let presenter = MovieDetailsPresenter(view: view, router: self, interactor: interactor, movieId: movieId)

    view.presenter = presenter

    return view
  }

}
