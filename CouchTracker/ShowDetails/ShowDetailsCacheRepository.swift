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
import Moya
import Moya_ObjectMapper
import TraktSwift

final class ShowDetailsCacheRepository: ShowDetailsRepository {
  private let cache: BasicCache<Shows, Show>

  init(traktProvider: TraktProvider) {
    let showsProvider = traktProvider.shows

    self.cache = MemoryCacheLevel<Shows, NSData>()
      .compose(MoyaFetcher(provider: showsProvider))
      .transformValues(JSONObjectTransfomer<Show>())
  }

  func fetchDetailsOfShow(with identifier: String, extended: Extended) -> Single<Show> {
    return cache.get(.summary(showId: identifier, extended: extended)).asObservable().asSingle()
  }
}
