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

final class TrendingCellService: TrendingCellInteractor {

  private let imageRepository: ImageRepository

  init(imageRepository: ImageRepository) {
    self.imageRepository = imageRepository
  }

  func fetchPosterImageURL(of type: TrendingViewModelType, with size: PosterImageSize?) -> Observable<URL> {
    var observable: Observable<ImagesEntity> = Observable.empty()

    if case .movie(let movieId) = type {
      observable = imageRepository.fetchImages(for: movieId, posterSize: size, backdropSize: nil)
    }

    return observable.flatMap { images -> Observable<URL> in
      guard let imageLink = images.posterImage()?.link,
        let imageURL = URL(string: imageLink) else {
        return Observable.empty()
      }

      return Observable.just(imageURL)
    }
  }
}
