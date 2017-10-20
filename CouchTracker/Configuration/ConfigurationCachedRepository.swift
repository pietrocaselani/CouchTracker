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
import RxSwift
import TMDBSwift

final class ConfigurationCachedRepository: ConfigurationRepository {

  private let cache: BasicCache<ConfigurationService, Configuration>

  init(tmdbProvider: TMDBProvider) {
    self.cache = MemoryCacheLevel<ConfigurationService, NSData>()
      .compose(DiskCacheLevel<ConfigurationService, NSData>())
      .compose(MoyaFetcher(provider: tmdbProvider.configuration))
      .transformValues(JSONObjectTransfomer<Configuration>())
  }

  func fetchConfiguration() -> Observable<Configuration> {
    let scheduler = SerialDispatchQueueScheduler(qos: .background)
    return cache.get(.configuration).asObservable().subscribeOn(scheduler).observeOn(scheduler)
  }
}
