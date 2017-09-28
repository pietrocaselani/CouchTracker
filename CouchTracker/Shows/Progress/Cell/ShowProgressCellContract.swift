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

import RxSwift

protocol ShowProgressCellView: class {
  var presenter: ShowProgressCellPresenter! { get set }

  func show(viewModel: WatchedShowViewModel)
  func showPosterImage(with url: URL)
}

protocol ShowProgressCellPresenter: class {
  init(view: ShowProgressCellView, interactor: ShowProgressCellInteractor, viewModel: WatchedShowViewModel)

  func viewWillAppear()
}

protocol ShowProgressCellInteractor: class {
  init(imageRepository: ImageRepository)

  func fetchPosterImageURL(for tmdbId: Int, with size: PosterImageSize?) -> Observable<URL>
}
