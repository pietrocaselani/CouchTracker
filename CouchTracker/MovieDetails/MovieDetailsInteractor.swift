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

final class MovieDetailsInteractor: MovieDetailsInteractorInput {

  private let store: MovieDetailsStoreInput
  private let genreStore: GenreStoreInput

  init(store: MovieDetailsStoreInput, genreStore: GenreStoreInput) {
    self.store = store
    self.genreStore = genreStore
  }

  func fetchDetails(movieId: String) -> Observable<Movie> {
    return store.fetchDetails(movieId: movieId)
  }

  func fetchGenres() -> Observable<[Genre]> {
    return genreStore.fetchMoviesGenres()
  }
}
