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

final class MovieDetailsService: MovieDetailsInteractor {

  private let repository: MovieDetailsRepository
  private let genreRepository: GenreRepository
  private let imageRepository: MovieImageRepository
  private let movieIds: MovieIds
  private let scheduler: SchedulerType

  init(repository: MovieDetailsRepository, genreRepository: GenreRepository,
       imageRepository: MovieImageRepository, movieIds: MovieIds, scheduler: SchedulerType) {
    self.repository = repository
    self.genreRepository = genreRepository
    self.imageRepository = imageRepository
    self.movieIds = movieIds
    self.scheduler = scheduler
  }

  convenience init(repository: MovieDetailsRepository, genreRepository: GenreRepository,
                   imageRepository: MovieImageRepository, movieIds: MovieIds) {
    let scheduler = SerialDispatchQueueScheduler(qos: DispatchQueue(label: "movieDetailsServiceQueue").qos)
    self.init(repository: repository, genreRepository: genreRepository,
              imageRepository: imageRepository, movieIds: movieIds, scheduler: scheduler)
  }

  func fetchDetails() -> Observable<MovieEntity> {
    let tmdbId = movieIds.tmdb ?? -1

    let detailsObservable = repository.fetchDetails(movieId: movieIds.slug)
    let genresObservable = genreRepository.fetchMoviesGenres()
    let imagesObservable = imageRepository.fetchImages(for: tmdbId, posterSize: .w780, backdropSize: .w780)

    return Observable.combineLatest(detailsObservable, genresObservable, imagesObservable) { (movie, genres, images) -> MovieEntity in
      let movieGenres = genres.filter { genre -> Bool in
        return movie.genres?.contains(genre.slug) ?? false
      }

      return entity(for: movie, with: images, genres: movieGenres)
    }
  }
}
