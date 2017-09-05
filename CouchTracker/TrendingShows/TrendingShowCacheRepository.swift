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
import Carlos
import Trakt_Swift
import Moya

final class TrendingShowCacheRepository: TrendingShowRepository {

  private let cache: BasicCache<Shows, [TrendingShow]>

  init(traktProvider: TraktProvider) {
    let showsProvider = traktProvider.shows

    let fetcher = MoyaFetcher(provider: showsProvider)

    self.cache = MemoryCacheLevel<Shows, NSData>()
        .compose(DiskCacheLevel<Shows, NSData>())
        .compose(fetcher)
        .transformValues(JSONArrayTransfomer<TrendingShow>())
  }

  func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShow]> {
    let scheduler = SerialDispatchQueueScheduler(qos: .background)

    return cache.get(.trending(page: page, limit: limit, extended: .full))
        .asObservable()
        .subscribeOn(scheduler)
        .observeOn(scheduler)
  }

}
