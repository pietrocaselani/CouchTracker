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
    let imagesObservable: Observable<ImagesEntity>

    switch type {
      case .movie(let tmdbMovieId):
        imagesObservable = imageRepository.fetchMovieImages(for: tmdbMovieId, posterSize: size, backdropSize: nil)
      case .show(let tmdbShowId):
        let single = imageRepository.fetchShowImages(for: tmdbShowId, posterSize: size, backdropSize: nil)
        imagesObservable = single.asObservable()
    }

    return imagesObservable.flatMap { images -> Observable<URL> in
      guard let imageLink = images.posterImage()?.link,
        let imageURL = URL(string: imageLink) else {
          return Observable.empty()
      }

      return Observable.just(imageURL)
    }
  }
}
