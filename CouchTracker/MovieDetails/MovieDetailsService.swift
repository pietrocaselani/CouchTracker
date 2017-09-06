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
  private let imageRepository: ImageRepository
  private let movieIds: MovieIds
  private let scheduler: SchedulerType

  init(repository: MovieDetailsRepository, genreRepository: GenreRepository,
       imageRepository: ImageRepository, movieIds: MovieIds, scheduler: SchedulerType) {
    self.repository = repository
    self.genreRepository = genreRepository
    self.imageRepository = imageRepository
    self.movieIds = movieIds
    self.scheduler = scheduler
  }

  convenience init(repository: MovieDetailsRepository, genreRepository: GenreRepository,
                   imageRepository: ImageRepository, movieIds: MovieIds) {
    let scheduler = SerialDispatchQueueScheduler(qos: DispatchQueue(label: "movieDetailsServiceQueue").qos)
    self.init(repository: repository, genreRepository: genreRepository,
              imageRepository: imageRepository, movieIds: movieIds, scheduler: scheduler)
  }

  func fetchDetails() -> Observable<MovieEntity> {
    let detailsObservable = repository.fetchDetails(movieId: movieIds.slug)
    let genresObservable = genreRepository.fetchMoviesGenres()

    return Observable.combineLatest(detailsObservable, genresObservable) {
      let movie = $0.0
      let movieGenres = $0.1.filter { genre -> Bool in
        return movie.genres?.contains(genre.slug) ?? false
      }

      return entity(for: movie, with: movieGenres)
    }
  }

  func fetchImages() -> Observable<ImagesEntity> {
    guard let tmdbId = movieIds.tmdb else { return Observable.empty() }
    return imageRepository.fetchImages(for: tmdbId, posterSize: .w780, backdropSize: .w780)
  }
}
