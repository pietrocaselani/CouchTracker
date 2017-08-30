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
import TMDB_Swift

final class ListMoviesService: ListMoviesInteractor {

  private let repository: ListMoviesRepository
  private let movieImageRepository: MovieImageRepository
  private let scheduler: SchedulerType

  convenience init(repository: ListMoviesRepository, movieImageRepository: MovieImageRepository) {
    let scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQueue(label: "listMoviesServiceQueue").qos)
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
      Observable.from(trendingMovies).flatMap { [unowned self] trendingMovie -> Observable<TrendingMovieEntity> in
        return self.movieImageRepository.fetchImages(for: trendingMovie.movie.ids.tmdb ?? -1)
          .observeOn(self.scheduler)
          .flatMap { images -> Observable<(TrendingMovie, ImagesEntity)> in
            return Observable.just((trendingMovie, images))
          }.map { (trendingMovie, images) -> TrendingMovieEntity in
            return entity(for: trendingMovie, with: images)
        }
      }
      }.subscribeOn(scheduler)

    return moviesObservable.toArray().flatMap { movies -> Observable<[TrendingMovieEntity]> in
      return movies.count == 0 ? Observable.empty() : Observable.just(movies)
    }
  }
}
