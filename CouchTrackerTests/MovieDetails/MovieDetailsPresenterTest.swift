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

import XCTest

final class MovieDetailsPresenterTest: XCTestCase {

  let view = MovieDetailsViewMock()
  let router = MovieDetailsRouterMock()

  func testMovieDetailsPresenter_fetchSuccess_andPresentMovieDetails() {
    let movie = createMovieDetailsMock()
    let genreStore = GenreStoreMock()
    let store = MovieDetailsStoreMock(movie: movie)
    let interactor = MovieDetailsUseCase(repository: store , genreRepository: genreStore, movieId: movie.ids.slug)
    let presenter = MovieDetailsiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.viewDidLoad()

    let dateFormatter = TraktDateTransformer.dateTransformer.dateFormatter

    let genres = movie.genres?.map { movieGenre -> String in
      let g = genreStore.genres.first(where: { genre -> Bool in
        genre.slug == movieGenre
      })

      return g?.name ?? ""
    } ?? [String]()

    let viewModel = MovieDetailsViewModel(
        title: movie.title ?? "TBA",
        tagline: movie.tagline ?? "",
        overview: movie.overview ?? "",
        genres: genres.joined(separator: " | "),
        releaseDate: movie.released == nil ? "Unknown" : dateFormatter.string(from: movie.released!))

    XCTAssertTrue(view.invokedShow)
    XCTAssertEqual(view.invokedShowParameters?.details, viewModel)
  }

  func testMovieDetailsPresenter_fetchFailure_andPresentErrorMessage() {
    let movie = createMovieDetailsMock()
    let errorMessage = "There is no active connection"
    let detailsError = MovieDetailsError.noConnection(errorMessage)
    let store = ErrorMovieDetailsStoreMock(error: detailsError)
    let interactor = MovieDetailsUseCase(repository: store, genreRepository: GenreStoreMock(), movieId: movie.ids.slug)
    let presenter = MovieDetailsiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.viewDidLoad()

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, errorMessage)
  }

  func testMovieDetailsPresenter_fetchFailure_andIsCustomError() {
    let movie = createMovieDetailsMock()
    let errorMessage = "Custom details error"
    let error = NSError(domain: "com.arctouch.CouchTracker", code: 10, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    let store = ErrorMovieDetailsStoreMock(error: error)
    let interactor = MovieDetailsUseCase(repository: store, genreRepository: GenreStoreMock(), movieId: movie.ids.slug)
    let presenter = MovieDetailsiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.viewDidLoad()

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, errorMessage)
  }

}
