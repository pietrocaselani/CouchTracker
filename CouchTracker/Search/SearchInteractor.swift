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
import Trakt

final class SearchInteractor: SearchInteractorLayer {

  private let store: SearchStoreLayer

  init(store: SearchStoreLayer) {
    self.store = store
  }

  func searchMovies(query: String) -> Observable<[SearchResult]> {
    return store.search(query: query, types: [.movie], page: 0, limit: 50)
  }
}
