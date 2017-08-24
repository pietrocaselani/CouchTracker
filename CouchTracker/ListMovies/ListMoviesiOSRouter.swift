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

final class ListMoviesiOSRouter: ListMoviesRouter {

  private weak var navigationController: UINavigationController?
  private let apiProvider: APIProvider

  init(navigationController: UINavigationController, apiProvider: APIProvider) {
    self.navigationController = navigationController
    self.apiProvider = apiProvider
  }

  func showDetails(of movie: TrendingMovie) {
    let movieId = movie.movie.ids.slug
    guard let view =
      MovieDetailsModule.setupModule(apiProvider: apiProvider, movieId: movieId) as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    navigationController?.pushViewController(view, animated: true)
  }
}
