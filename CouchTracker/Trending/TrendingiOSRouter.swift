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
import TraktSwift
import RxSwift

final class TrendingiOSRouter: TrendingRouter, AppConfigurationsPresentable {
  private weak var viewController: UIViewController?
  private let traktProvider: TraktProvider
  private let tmdbProvider: TMDBProvider
  private let disposeBag = DisposeBag()

  init(viewController: UIViewController, traktProvider: TraktProvider, tmdbProvider: TMDBProvider) {
    self.viewController = viewController
    self.traktProvider = traktProvider
    self.tmdbProvider = tmdbProvider
  }

  func showDetails(of movie: MovieEntity) {
    let movieIds = movie.ids
    let view = MovieDetailsModule.setupModule(traktProvider: traktProvider,
                                              tmdbProvider: tmdbProvider, movieIds: movieIds)

    present(view: view)
  }

  func showDetails(of show: ShowEntity) {
    let showIds = show.ids
    let view = ShowDetailsModule.setupModule(traktProvider: traktProvider, tmdbProvider: tmdbProvider, showIds: showIds)
    present(view: view)
  }

  func showError(message: String) {
    guard let viewController = viewController else { return }

    let errorAlert = UIAlertController.createErrorAlert(message: message)
    viewController.present(errorAlert, animated: true)
  }

  func showAppSettings() {
    guard let currentViewController = viewController else { return }

    let configurationsView = AppConfigurationsModule.setupModule(traktProvider: traktProvider)

    guard let configurationsViewController = configurationsView as? UIViewController else {
      fatalError("configurationsView should be an instance of UIViewController")
    }

    configurationsViewController.modalPresentationStyle = .overCurrentContext

    let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    closeButton.rx.tap.subscribe(onNext: { _ in
      currentViewController.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)

    let navigationController = configurationsViewController as? UINavigationController
    navigationController?.topViewController?.navigationItem.leftBarButtonItem = closeButton

    currentViewController.present(configurationsViewController, animated: true, completion: nil)
  }

  private func present(view: BaseView) {
    guard let navigationController = viewController?.navigationController else { return }

    guard let viewController = view as? UIViewController else {
      fatalError("view should be an instance of UIViewController")
    }

    navigationController.pushViewController(viewController, animated: true)
  }
}
