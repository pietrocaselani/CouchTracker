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

import Carlos
import Moya
import RxSwift

final class MovieDetailsStore: MovieDetailsStoreInput {

  private let moviesProvider: RxMoyaProvider<Movies>
  private let cache: BasicCache<Movies, NSData>

  init(trakt: TraktV2) {
    self.moviesProvider = trakt.movies

    self.cache = MemoryCacheLevel()
        .compose(MoyaFetcher(provider: moviesProvider))
  }

  func fetchDetails(movieId: String) -> Observable<Movie> {
    return cache.get(.summary(movieId: movieId, extended: .full))
    .asObservable()
    .mapObject(Movie.self)
  }
}