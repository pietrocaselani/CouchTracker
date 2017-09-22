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

  init(repository: TrendingRepository, imageRepository: ImageRepository) {
    self.repository = repository
    self.imageRepository = imageRepository
  }

  func fetchShows(page: Int, limit: Int) -> Observable<[TrendingShowEntity]> {
    return repository.fetchShows(page: page, limit: limit)
      .map { [unowned self] in self.mapTrendingShowsToEntities($0) }
  }

  func fetchMovies(page: Int, limit: Int) -> Observable<[TrendingMovieEntity]> {
    return repository.fetchMovies(page: page, limit: limit)
      .map { [unowned self] in self.mapTrendingMoviesToEntities($0) }
  }

  private func mapTrendingShowsToEntities(_ trendingShows: [TrendingShow]) -> [TrendingShowEntity] {
    return trendingShows.map { ShowEntityMapper.entity(for: $0) }
  }

  private func mapTrendingMoviesToEntities(_ trendingMovies: [TrendingMovie]) -> [TrendingMovieEntity] {
    return trendingMovies.map { MovieEntityMapper.entity(for: $0) }
  }
}
