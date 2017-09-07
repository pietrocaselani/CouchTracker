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

import Foundation
import RxSwift

final class TrendingCellViewMock: TrendingCellView {
  var presenter: TrendingCellPresenter!
  var invokedShowPosterImage = false
  var invokedShowViewModel = false
  var invokedPosterImageParameters: (url: URL, Void)?
  var invokedShowViewModelParameters: (viewModel: TrendingCellViewModel, Void)?

  func showPosterImage(with url: URL) {
    invokedShowPosterImage = true
    invokedPosterImageParameters = (url, ())
  }

  func show(viewModel: TrendingCellViewModel) {
    invokedShowViewModel = true
    invokedShowViewModelParameters = (viewModel, ())
  }
}

final class TrendingCellInteractorMock: TrendingCellInteractor {
  private let imageRepository: ImageRepository

  init(imageRepository: ImageRepository) {
    self.imageRepository = imageRepository
  }

  func fetchPosterImageURL(of type: TrendingViewModelType, with size: PosterImageSize?) -> Observable<URL> {
    if case .movie(let tmdbId) = type {
      let observable = imageRepository.fetchImages(for: tmdbId, posterSize: size, backdropSize: nil)
      return observable.flatMap { imageEntity -> Observable<URL> in
        guard let imageLink = imageEntity.posterImage()?.link, let url = URL(string: imageLink) else {
          return Observable.empty()
        }

        return Observable.just(url)
      }
    }

    return Observable.empty()
  }

}
