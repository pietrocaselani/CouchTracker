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
import PiedPiper
import RxSwift

final class ListMoviesStore: ListMoviesStoreInput {

  private let moviesProvider: RxMoyaProvider<Movies>
  private let cache: BasicCache<Movies, [TrendingMovie]>

  init(trakt: TraktV2) {
    self.moviesProvider = trakt.movies

    let fetcher = MoyaFetcher(provider: moviesProvider).pooled()

    self.cache = MemoryCacheLevel<Movies, NSData>()
        .compose(DiskCacheLevel<Movies, NSData>())
        .compose(fetcher)
        .transformValues(JSONArrayTransfomer<TrendingMovie>())
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    return cache.get(.trending(page: page, limit: limit, extended: .full))
        .asObservable()
  }

}
