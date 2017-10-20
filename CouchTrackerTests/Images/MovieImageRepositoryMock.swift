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
import TMDBSwift
import Moya_ObjectMapper
import Moya

final class EmptyImageRepositoryMock: ImageRepository {
  init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {}

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    return Observable.empty()
  }

  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
    return Single.never()
  }

  func fetchEpisodeImages(for episode: EpisodeEntity, size: EpisodeImageSizes?) -> Observable<URL> {
    return Observable.empty()
  }
}

final class ImagesRepositorySampleMock: ImageRepository {
  private let images: ImagesEntity

  init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {
    let imageEntities = [ImageEntity(link: "", width: 10, height: 10, iso6391: nil, aspectRatio: 1.2, voteAverage: 2.3, voteCount: 5)]
    self.images = ImagesEntity(identifier: -1, backdrops: imageEntities, posters: imageEntities, stills: [ImageEntity]())
  }

  init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository, images: ImagesEntity) {
    self.images = images
  }

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    return Observable.just(images)
  }

  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
    return Single.just(images)
  }

  func fetchEpisodeImages(for episode: EpisodeEntity, size: EpisodeImageSizes?) -> Observable<URL> {
    return Observable.empty()
  }
}


final class ImageRepositoryMock: ImageRepository {
  private let provider: TMDBProvider
  private let configuration: ConfigurationRepository

  init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {
    self.provider = tmdb
    self.configuration = cofigurationRepository
  }

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    let observable = configuration.fetchConfiguration().flatMap { [unowned self] config -> Observable<ImagesEntity> in
      return self.provider.movies.request(.images(movieId: movieId)).mapObject(Images.self).map {
        let posterSize = posterSize ?? .w342
        let backdropSize = backdropSize ?? .w300

        return ImagesEntityMapper.entity(for: $0, using: config, posterSize: posterSize, backdropSize: backdropSize)
      }
    }

    return observable
  }

  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
    let configurationObservable = configuration.fetchConfiguration()
    let imagesObservable = provider.shows.request(.images(showId: showId)).mapObject(Images.self)

    return Observable.combineLatest(imagesObservable, configurationObservable) {
      let posterSize = posterSize ?? .w342
      let backdropSize = backdropSize ?? .w300
      return ImagesEntityMapper.entity(for: $0, using: $1, posterSize: posterSize, backdropSize: backdropSize)
    }.asSingle()
  }

  func fetchEpisodeImages(for episode: EpisodeEntity, size: EpisodeImageSizes?) -> Observable<URL> {
    return Observable.empty()
  }
}
