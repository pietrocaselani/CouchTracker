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
import TraktSwift
import TMDBSwift

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
    return repository.fetchMovies(page: page, limit: limit).observeOn(scheduler).map {
      $0.map { trendingMovie -> TrendingMovieEntity in
        MovieEntityMapper.entity(for: trendingMovie)
      }
    }
  }

  private func mapTrendingShowsToEntities(_ trendingShows: [TrendingShow]) -> [TrendingShowEntity] {
    return trendingShows.map { ShowEntityMapper.entity(for: $0) }
  }
}
