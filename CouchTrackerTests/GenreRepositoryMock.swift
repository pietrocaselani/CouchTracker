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
import Trakt_Swift

final class GenreRepositoryMock: GenreRepository {

  let genres: [Genre]

  init() {
    let data = Genres.list(.shows).sampleData
    self.genres = try! data.mapArray(Genre.self)
  }

  func fetchShowsGenres() -> Observable<[Genre]> {
    return Observable.just(genres)
  }

  func fetchMoviesGenres() -> Observable<[Genre]> {
    return Observable.just(genres)
  }

}