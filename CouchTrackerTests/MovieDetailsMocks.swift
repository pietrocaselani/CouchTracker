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

import Foundation
import RxSwift

final class MovieDetailsViewMock: MovieDetailsView {
  var invokedPresenterSetter = false
  var invokedPresenterSetterCount = 0
  var invokedPresenter: MovieDetailsPresenterLayer?
  var invokedPresenterList = [MovieDetailsPresenterLayer!]()
  var invokedPresenterGetter = false
  var invokedPresenterGetterCount = 0
  var stubbedPresenter: MovieDetailsPresenterLayer!
  var presenter: MovieDetailsPresenterLayer! {
    set {
      invokedPresenterSetter = true
      invokedPresenterSetterCount += 1
      invokedPresenter = newValue
      invokedPresenterList.append(newValue)
    }
    get {
      invokedPresenterGetter = true
      invokedPresenterGetterCount += 1
      return stubbedPresenter
    }
  }
  var invokedShow = false
  var invokedShowCount = 0
  var invokedShowParameters: (details: MovieDetailsViewModel, Void)?
  var invokedShowParametersList = [(details: MovieDetailsViewModel, Void)]()

  func show(details: MovieDetailsViewModel) {
    invokedShow = true
    invokedShowCount += 1
    invokedShowParameters = (details, ())
    invokedShowParametersList.append((details, ()))
  }
}

final class MovieDetailsRouterMock: MovieDetailsRouter {
  var invokedShowError = false
  var invokedShowErrorCount = 0
  var invokedShowErrorParameters: (message: String, Void)?
  var invokedShowErrorParametersList = [(message: String, Void)]()

  func showError(message: String) {
    invokedShowError = true
    invokedShowErrorCount += 1
    invokedShowErrorParameters = (message, ())
    invokedShowErrorParametersList.append((message, ()))
  }
}

final class ErrorMovieDetailsStoreMock: MovieDetailsStoreLayer {

  private let error: Error

  init(error: Error) {
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
