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

protocol TrendingCellView: class {
  var presenter: TrendingCellPresenter! { get set }

  func show(viewModel: TrendingCellViewModel)
  func showPosterImage(with url: URL)
}

protocol TrendingCellPresenter: class {
  init(view: TrendingCellView, interactor: TrendingCellInteractor, viewModel: TrendingViewModel)

  func viewDidLoad()
}

protocol TrendingCellInteractor: class {
  init(imageRepository: ImageRepository)

  func fetchPosterImageURL(of type: TrendingViewModelType, with size: PosterImageSize?) -> Observable<URL>
}
