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

func createMoviesGenresMock() -> [Genre] {
  let jsonArray = parseToJSONArray(data: Genres.list(.movies).sampleData)
  return try! jsonArray.map { try Genre(JSON: $0) }
}

func createShowsGenresMock() -> [Genre] {
  let jsonArray = parseToJSONArray(data: Genres.list(.shows).sampleData)
  return try! jsonArray.map { try Genre(JSON: $0) }
}

final class GenreRepositoryMock: GenreRepository {
  func fetchShowsGenres() -> Observable<[Genre]> {
    return Observable.just(createShowsGenresMock())
  }

  func fetchMoviesGenres() -> Observable<[Genre]> {
    return Observable.just(createMoviesGenresMock())
  }
}
