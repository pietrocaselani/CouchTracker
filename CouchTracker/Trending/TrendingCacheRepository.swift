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
import TraktSwift

final class TrendingCacheRepository: TrendingRepository {

  private let moviesCache: BasicCache<Movies, [TrendingMovie]>
  private let showsCache: BasicCache<Shows, [TrendingShow]>

  init(traktProvider: TraktProvider) {
    let moviesProvider = traktProvider.movies
    let showsProvider = traktProvider.shows

    self.moviesCache = MemoryCacheLevel<Movies, NSData>()
      .compose(DiskCacheLevel<Movies, NSData>())
      .compose(MoyaFetcher(provider: moviesProvider))
      .transformValues(JSONArrayTransfomer<TrendingMovie>())

    self.showsCache = MemoryCacheLevel<Shows, NSData>()
      .compose(DiskCacheLevel<Shows, NSData>())
      .compose(MoyaFetcher(provider: showsProvider))
      .transformValues(JSONArrayTransfomer<TrendingShow>())
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovie]> {
    let scheduler = SerialDispatchQueueScheduler(qos: .background)
    return moviesCache.get(.trending(page: page, limit: limit, extended: .full))
      .asObservable()
      .subscribeOn(scheduler)
      .observeOn(scheduler)
  }

  func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
    let scheduler = SerialDispatchQueueScheduler(qos: .background)

    return showsCache.get(.trending(page: page, limit: limit, extended: .full))
      .asObservable()
      .subscribeOn(scheduler)
      .observeOn(scheduler)
  }
}
