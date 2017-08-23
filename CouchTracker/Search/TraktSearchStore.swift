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
import Moya
import Moya_ObjectMapper

final class TraktSearchStore: SearchStoreInput {

  private let provider: RxMoyaProvider<Search>

  init(trakt: TraktV2) {
    self.provider = trakt.search
  }

  func search(query: String, types: [SearchType]) -> Observable<[SearchResult]> {
    let target = Search.textQuery(types: types, query: query)

    let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

    return provider.request(target)
        .subscribeOn(scheduler)
        .observeOn(scheduler)
        .mapArray(SearchResult.self)
  }
}
