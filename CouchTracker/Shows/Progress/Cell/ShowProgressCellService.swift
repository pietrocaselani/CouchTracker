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

final class ShowProgressCellService: ShowProgressCellInteractor {
  private let imageRepository: ImageRepository

  init(imageRepository: ImageRepository) {
    self.imageRepository = imageRepository
  }

  func fetchPosterImageURL(for tmdbId: Int, with size: PosterImageSize?) -> Observable<URL> {
    let observable = imageRepository.fetchShowImages(for: tmdbId, posterSize: size, backdropSize: nil).asObservable()

    return observable.flatMap { images -> Observable<URL> in
      guard let imageLink = images.posterImage()?.link, let url = URL(string: imageLink) else {
        return Observable.empty()
      }
      return Observable.just(url)
    }
  }
}
