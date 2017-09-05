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
import Moya
import Trakt_Swift
import TMDB_Swift

final class ListMoviesService: ListMoviesInteractor {

  private let repository: ListMoviesRepository
  private let movieImageRepository: MovieImageRepository
  private let scheduler: SchedulerType

  convenience init(repository: ListMoviesRepository, movieImageRepository: MovieImageRepository) {
    let scheduler = SerialDispatchQueueScheduler(qos: DispatchQueue(label: "listMoviesServiceQueue").qos)
    self.init(repository: repository, movieImageRepository: movieImageRepository, scheduler: scheduler)
  }

  init(repository: ListMoviesRepository, movieImageRepository: MovieImageRepository, scheduler: SchedulerType) {
    self.repository = repository
    self.movieImageRepository = movieImageRepository
    self.scheduler = scheduler
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovieEntity]> {
    let moviesObservable = repository.fetchMovies(page: page, limit: limit).observeOn(scheduler).map {
      $0.filter {
        $0.movie.ids.tmdb != nil
      }
      }.flatMap { trendingMovies -> Observable<TrendingMovieEntity> in
        return Observable.from(trendingMovies).flatMap { [unowned self] movie -> Observable<TrendingMovieEntity> in
          let tmdbId = movie.movie.ids.tmdb ?? -1
          return self.movieImageRepository.fetchImages(for: tmdbId, posterSize: .w342 , backdropSize: .w780)
            .observeOn(self.scheduler)
            .delay(0.25, scheduler: self.scheduler)
            .flatMap { images -> Observable<(TrendingMovie, ImagesEntity)> in
              return Observable.just((movie, images))
            }.map { [unowned self] in self.mapToEntity($0.0, $0.1) }
        }
      }.subscribeOn(scheduler)

    return moviesObservable.toArray().flatMap { movies -> Observable<[TrendingMovieEntity]> in
      return movies.count == 0 ? Observable.empty() : Observable.just(movies)
      }.retryWhen { errorObservable -> Observable<[TrendingMovieEntity]> in
        return errorObservable.flatMap { error -> Observable<[TrendingMovieEntity]> in
          guard let moyaError = error as? MoyaError,
            moyaError.response?.statusCode == TMDBError.toManyRequests.rawValue else {
            return Observable.error(error)
          }

          return self.fetchMovies(page: page, limit: limit).delay(10, scheduler: self.scheduler)
        }
      }
  }

  private func mapToEntity(_ trendingMovie: TrendingMovie, _ images: ImagesEntity) -> TrendingMovieEntity {
    return entity(for: trendingMovie, with: images)
  }
}
