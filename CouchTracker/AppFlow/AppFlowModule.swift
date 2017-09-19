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

final class AppFlowModule {
  private init() {}

  static func setupModule(traktProvider: TraktProvider, tmdbProvider: TMDBProvider) -> BaseView {
    let trendingView = TrendingModule.setupModule(traktProvider: traktProvider, tmdbProvider: tmdbProvider)
    guard let trendingViewController = trendingView as? UIViewController else {
      fatalError("trendingView should be an instance of UIViewController")
    }

    let showsView = ShowsManagerModule.setupModule()
    guard let showsViewController = showsView as? UIViewController else {
      fatalError("showsView should be an instance of UIViewController")
    }

    let viewControllers = [trendingViewController, showsViewController]

    guard let appFlowViewController = R.storyboard.appFlow.appFlowViewController() else {
      fatalError("Can't instantiate AppFlowViewController from Storyboard")
    }

    appFlowViewController.viewControllers = viewControllers

    return appFlowViewController
  }
}
