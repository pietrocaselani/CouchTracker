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

final class TrendingService: TrendingInteractor {
  private let repository: TrendingRepository
  private let imageRepository: ImageRepository
  private let scheduler: SchedulerType

  convenience init(repository: TrendingRepository, imageRepository: ImageRepository) {
    let scheduler = SerialDispatchQueueScheduler(qos: DispatchQueue(label: "listMoviesServiceQueue").qos)
    self.init(repository: repository, imageRepository: imageRepository, scheduler: scheduler)
  }

  init(repository: TrendingRepository, imageRepository: ImageRepository, scheduler: SchedulerType) {
    self.repository = repository
    self.imageRepository = imageRepository
    self.scheduler = scheduler
  }

  func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShowEntity]> {
    let observable = repository.fetchShows(page: page, limit: limit)
      .observeOn(scheduler)
      .map { [unowned self] in self.mapTrendingShowsToEntities($0) }
    return observable
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovieEntity]> {
    let moviesObservable = repository.fetchMovies(page: page, limit: limit).observeOn(scheduler).map {
      $0.filter { $0.movie.ids.tmdb != nil }
      }.flatMap { trendingMovies -> Observable<TrendingMovieEntity> in
        return Observable.from(trendingMovies).flatMap { [unowned self] movie -> Observable<TrendingMovieEntity> in
          guard let tmdbId = movie.movie.ids.tmdb else { fatalError("TMDB id is null What a terrible failure") }
          return self.imageRepository.fetchImages(for: tmdbId, posterSize: .w342, backdropSize: .w780)
            .observeOn(self.scheduler)
            .flatMap { images -> Observable<(TrendingMovie, ImagesEntity)> in
              return Observable.just((movie, images))
            }.map { (trendingMovie, images) -> TrendingMovieEntity in
              return MovieEntityMapper.entity(for: trendingMovie, with: images)
          }
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

          return self.fetchMovies(page: page, limit: limit).delay(1, scheduler: self.scheduler)
        }
      }
  }

  private func mapTrendingShowsToEntities(_ trendingShows: [TrendingShow]) -> [TrendingShowEntity] {
    return trendingShows.map { ShowEntityMapper.entity(for: $0) }
  }
}
