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
import Trakt_Swift

final class MovieDetailsPresenterTest: XCTestCase {

  let view = MovieDetailsViewMock()
  let router = MovieDetailsRouterMock()
  let genreRepository = GenreRepositoryMock()

  func testMovieDetailsPresenter_fetchSuccess_andPresentMovieDetails() {
    let movie = createMovieDetailsMock()
    let repository = MovieDetailsStoreMock(movie: movie)
    let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
                                             imageRepository: movieImageRepositoryRealMock, movieIds: movie.ids)
    let presenter = MovieDetailsiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.viewDidLoad()

    let dateFormatter = TraktDateTransformer.dateTransformer.dateFormatter

    let genres = createMoviesGenresMock()
    let movieGenres = genres.filter { movie.genres?.contains($0.slug) ?? false }.map { $0.name }

    let images = createImagesMock(movieId: movie.ids.tmdb ?? -1)
    let imagesEntity = ImagesEntityMapper.entity(for: images, using: configurationMock,
                                                 posterSize: .w342, backdropSize: .w300)

    let viewModel = MovieDetailsViewModel(
        title: movie.title ?? "TBA",
        tagline: movie.tagline ?? "",
        overview: movie.overview ?? "",
        genres: movieGenres.joined(separator: " | "),
        releaseDate: movie.released == nil ? "Unknown" : dateFormatter.string(from: movie.released!),
        posterLink: imagesEntity.posterImage()?.link,
        backdropLink: imagesEntity.backdropImage()?.link)

    XCTAssertTrue(view.invokedShow)
    XCTAssertEqual(view.invokedShowParameters?.details, viewModel)
  }

  func testMovieDetailsPresenter_fetchFailure_andPresentErrorMessage() {
    let movie = createMovieDetailsMock()
    let errorMessage = "There is no active connection"
    let detailsError = MovieDetailsError.noConnection(errorMessage)
    let repository = ErrorMovieDetailsStoreMock(error: detailsError)
    let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
                                             imageRepository: movieImageRepositoryMock, movieIds: movie.ids)
    let presenter = MovieDetailsiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.viewDidLoad()

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, errorMessage)
  }

  func testMovieDetailsPresenter_fetchFailure_andIsCustomError() {
    let movie = createMovieDetailsMock()
    let errorMessage = "Custom details error"
    let error = NSError(domain: "com.arctouch.CouchTracker", code: 10, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    let repository = ErrorMovieDetailsStoreMock(error: error)
    let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
                                             imageRepository: movieImageRepositoryMock, movieIds: movie.ids)
    let presenter = MovieDetailsiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.viewDidLoad()

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, errorMessage)
  }
}
