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

final class MovieDetailsService: MovieDetailsInteractor {

  private let repository: MovieDetailsRepository
  private let genreRepository: GenreRepository
  private let movieId: String

  init(repository: MovieDetailsRepository, genreRepository: GenreRepository, movieId: String) {
    self.repository = repository
    self.genreRepository = genreRepository
    self.movieId = movieId
  }

  func fetchDetails() -> Observable<Movie> {
    return repository.fetchDetails(movieId: movieId)
  }

  func fetchGenres() -> Observable<[Genre]> {
    return genreRepository.fetchMoviesGenres()
  }
}
