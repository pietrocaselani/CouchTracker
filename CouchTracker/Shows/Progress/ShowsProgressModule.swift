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
import Carlos
import TraktSwift

final class ShowsProgressModule {
  private init() {}

  static var showsManagerOption: ShowsManagerOption {
    return ShowsManagerOption.progress
  }

  static func setupModule() -> BaseView {
    guard let view = R.storyboard.showsProgress.showsProgressViewController() else {
      fatalError("Can't instantiate showsProgressController from Shows storyboard")
    }

    let trakt = Environment.instance.trakt

    let carlosCache = CarlosCache(basicCache: MemoryCacheLevel<Int, NSData>().compose(DiskCacheLevel()))
    let cache = AnyCache(carlosCache)

    let repository = ShowsProgressAPIRepository(trakt: trakt, cache: cache)
    let interactor = ShowsProgressService(repository: repository)
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor)

    view.presenter = presenter

    return view
  }
}
