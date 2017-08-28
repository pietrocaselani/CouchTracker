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
import Trakt

final class ListMoviesiOSRouter: ListMoviesRouter {

  private weak var viewController: UIViewController?
  private let apiProvider: APIProvider

  init(viewController: UIViewController, apiProvider: APIProvider) {
    self.viewController = viewController
    self.apiProvider = apiProvider
  }

  func showDetails(of movie: TrendingMovie) {
    guard let navigationController = viewController?.navigationController else { return }

    let movieId = movie.movie.ids.slug
    guard let view =
      MovieDetailsModule.setupModule(apiProvider: apiProvider, movieId: movieId) as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    navigationController.pushViewController(view, animated: true)
  }

  func showError(message: String) {
    guard let viewController = viewController else { return }

    let errorAlert = UIAlertController.createErrorAlert(message: message)
    viewController.present(errorAlert, animated: true)
  }
}
