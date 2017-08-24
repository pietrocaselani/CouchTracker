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

import Moya
import ObjectMapper
import RxSwift

final class MovieDetailsViewMock: MovieDetailsView {

  var receivedErrorMessage: String?
  var receivedMovieDetails: MovieDetailsViewModel?
  var methodShowEmptyViewCalled = false

  var presenter: MovieDetailsPresenterLayer!

  func showEmptyView() {
    methodShowEmptyViewCalled = true
  }

  func show(details: MovieDetailsViewModel) {
    receivedMovieDetails = details
  }

  func show(error: String) {
    receivedErrorMessage = error
  }

}

final class ErrorMovieDetailsStoreMock: MovieDetailsStoreLayer {

  private let error: MovieDetailsError

  init(error: MovieDetailsError) {
    self.error = error
  }

  func fetchDetails(movieId: String) -> Observable<Movie> {
    return Observable.error(error)
  }

}

final class MovieDetailsStoreMock: MovieDetailsStoreLayer {

  private let movie: Movie

  init(movie: Movie) {
    self.movie = movie
  }

  func fetchDetails(movieId: String) -> Observable<Movie> {
    return Observable.just(movie).filter { $0.ids.slug == movieId }
  }
}

func createMovieDetailsMock() -> Movie {
  let jsonData = Movies.summary(movieId: "tron-legacy-2010", extended: .full).sampleData
  return try! jsonData.mapObject(Movie.self)
}
