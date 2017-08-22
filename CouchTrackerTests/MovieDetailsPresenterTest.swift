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
@testable import CouchTracker

final class MovieDetailsPresenterTest: XCTestCase {

  let router = EmptyMovieDetailsRouterMock()
  let view = MovieDetailsViewMock()

  func testMovieDetailsPresenter_fetchSuccess_andPresentMovieDetails() {
    let movie = createMovieDetailsMock()

    let genreStore = GenreStoreMock()

    let interactor = MovieDetailsInteractor(store: MovieDetailsStoreMock(movie: movie), genreStore: genreStore)

    let presenter = MovieDetailsPresenter(view: view, router: router, interactor: interactor, movieId: movie.ids.slug)

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

    XCTAssertEqual(view.receivedMovieDetails, viewModel)
  }

  func testMovieDetailsPresenter_fetchFailure_andPresentErrorMessage() {
    let movie = createMovieDetailsMock()

    let detailsError = MovieDetailsError.noConnection("There is no active connection")

    let interactor = MovieDetailsInteractor(store: ErrorMovieDetailsStoreMock(error: detailsError), genreStore: GenreStoreMock())

    let presenter = MovieDetailsPresenter(view: view, router: router, interactor: interactor, movieId: movie.ids.slug)

    presenter.viewDidLoad()

    XCTAssertEqual(view.receivedErrorMessage, detailsError.message)
  }

}
