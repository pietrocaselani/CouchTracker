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
import TraktSwift

final class TraktGenreRepository: GenreRepository {

  private let cache: BasicCache<Genres, [Genre]>

  init(traktProvider: TraktProvider) {
    let provider = traktProvider.genres

    self.cache = MemoryCacheLevel<Genres, NSData>()
        .compose(DiskCacheLevel<Genres, NSData>())
        .compose(MoyaFetcher(provider: provider))
        .transformValues(JSONArrayTransfomer<Genre>())
  }

  func fetchMoviesGenres() -> Observable<[Genre]> {
    return fetchGenres(mediaType: .movies)
  }

  func fetchShowsGenres() -> Observable<[Genre]> {
    return fetchGenres(mediaType: .shows)
  }

  private func fetchGenres(mediaType: GenreType) -> Observable<[Genre]> {
    return cache.get(.list(mediaType)).asObservable()
  }
}
