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
import TMDB_Swift
import Moya_ObjectMapper
import Moya

final class EmptyMovieImageRepositoryMock: MovieImageRepository {
  init(tmdbProvider: TMDBProvider, cofigurationRepository: ConfigurationRepository) {}

  func fetchImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    return Observable.empty()
  }
}

final class MovieImagesRepositorySampleMock: MovieImageRepository {
  private let images: ImagesEntity

  init(tmdbProvider: TMDBProvider, cofigurationRepository: ConfigurationRepository) {
    let imageEntities = [ImageEntity(link: "", width: 10, height: 10, iso6391: nil, aspectRatio: 1.2, voteAverage: 2.3, voteCount: 5)]
    self.images = ImagesEntity(identifier: -1, backdrops: imageEntities, posters: imageEntities)
  }

  init(tmdbProvider: TMDBProvider, cofigurationRepository: ConfigurationRepository, images: ImagesEntity) {
    self.images = images
  }

  func fetchImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    return Observable.just(images)
  }
}

final class MovieImageRepositoryMock: MovieImageRepository {
  private let provider: RxMoyaProvider<Movies>
  private let configuration: ConfigurationRepository

  init(tmdbProvider: TMDBProvider, cofigurationRepository: ConfigurationRepository) {
    self.provider = tmdbProvider.movies
    self.configuration = cofigurationRepository
  }

  func fetchImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    let observable = configuration.fetchConfiguration().flatMap { [unowned self] config -> Observable<ImagesEntity> in
      return self.provider.request(.images(movieId: movieId)).mapObject(Images.self).map {
        let pSize = posterSize ?? .w342
        let bSize = backdropSize ?? .w300

        return entity(for: $0, using: config, posterSize: pSize, backdropSize: bSize)
      }
    }

    return observable
  }
}