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
import Trakt_Swift

final class MovieDetailsViewMock: MovieDetailsView {
  var presenter: MovieDetailsPresenter!
  var invokedShow = false
  var invokedShowParameters: (details: MovieDetailsViewModel, Void)?
  var invokedShowImages = false
  var invokedShowImagesParameters: (images: MovieDetailsImageViewModel, Void)?

  func show(details: MovieDetailsViewModel) {
    invokedShow = true
    invokedShowParameters = (details, ())
  }

  func show(images: MovieDetailsImageViewModel) {
    invokedShowImages = true
    invokedShowImagesParameters = (images, ())
  }
}

final class MovieDetailsRouterMock: MovieDetailsRouter {
  var invokedShowError = false
  var invokedShowErrorParameters: (message: String, Void)?

  func showError(message: String) {
    invokedShowError = true
    invokedShowErrorParameters = (message, ())
  }
}

final class ErrorMovieDetailsStoreMock: MovieDetailsRepository {

  private let error: Error

  init(error: Error) {
    self.error = error
  }

  func fetchDetails(movieId: String) -> Observable<Movie> {
    return Observable.error(error)
  }
}

final class MovieDetailsStoreMock: MovieDetailsRepository {

  private let movie: Movie

  init(movie: Movie) {
    self.movie = movie
  }

  func fetchDetails(movieId: String) -> Observable<Movie> {
    return Observable.just(movie).filter {
      $0.ids.slug == movieId
    }
  }
}

final class MovieDetailsServiceMock: MovieDetailsInteractor {
  private let movieIds: MovieIds
  private let repository: MovieDetailsRepository
  private let genreRepository: GenreRepository
  private let imageRepository: ImageRepository

  init(repository: MovieDetailsRepository, genreRepository: GenreRepository,
       imageRepository: ImageRepository, movieIds: MovieIds) {
    self.repository = repository
    self.genreRepository = genreRepository
    self.imageRepository = imageRepository
    self.movieIds = movieIds
  }

  func fetchDetails() -> Observable<MovieEntity> {
    let detailsObservable = repository.fetchDetails(movieId: movieIds.slug)
    let genresObservable = genreRepository.fetchMoviesGenres()

    return Observable.combineLatest(detailsObservable, genresObservable) { (movie, genres) in
      let movieGenres = genres.filter { genre -> Bool in
        return movie.genres?.contains(genre.slug) ?? false
      }

      return MovieEntityMapper.entity(for: movie, with: movieGenres)
    }
  }

  func fetchImages() -> Observable<ImagesEntity> {
    guard let tmdbId = movieIds.tmdb else { return Observable.empty() }
    return imageRepository.fetchImages(for: tmdbId, posterSize: nil, backdropSize: nil)
  }
}

func createMockMovies() -> [TrendingMovie] {
  let jsonArray = parseToJSONArray(data: Movies.trending(page: 0, limit: 50, extended: .full).sampleData)
  return try! jsonArray.map { try TrendingMovie(JSON: $0) }
}

func createMovieMock(for movieId: String) -> Movie {
  let movies = createMockMovies()

  let trendingMovie = movies.first { $0.movie.ids.slug == movieId }

  return trendingMovie?.movie ?? createMovieDetailsMock(for: movieId)
}

func createMovieDetailsMock(for movieId: String) -> Movie {
  let jsonObject = parseToJSONObject(data: Movies.summary(movieId: movieId, extended: .full).sampleData)
  return try! Movie(JSON: jsonObject)
}

func createMovieDetailsMock() -> Movie {
  return createMovieDetailsMock(for: "tron-legacy-2010")
}
