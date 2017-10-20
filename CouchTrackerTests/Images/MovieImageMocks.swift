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

import TMDBSwift
import RxSwift

let imageRepositoryRealMock = ImageRepositoryMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)
let imageRepositoryMock = EmptyImageRepositoryMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)

final class ErrorImageRepositoryMock: ImageRepository {
  private var error: Error!

  convenience init(error: Error) {
    self.init(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock)
    self.error = error
  }

  init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {}

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    return Observable.error(error)
  }

  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Single<ImagesEntity> {
    return Single.error(error)
  }

  func fetchEpisodeImages(for episode: EpisodeEntity, size: EpisodeImageSizes?) -> Observable<URL> {
    return Observable.empty()
  }
}

func createMovieImagesRepositoryMock(_ images: ImagesEntity) -> ImageRepository {
  return ImagesRepositorySampleMock(tmdb: tmdbProviderMock, tvdb: tvdbProviderMock, cofigurationRepository: configurationRepositoryMock, images: images)
}

func createTMDBConfigurationMock() -> Configuration {
  let jsonObject = JSONParser.toObject(data: ConfigurationService.configuration.sampleData)
  return try! Configuration(JSON: jsonObject)
}

func createImagesMock(movieId: Int) -> Images {
  let jsonObject = JSONParser.toObject(data: Movies.images(movieId: movieId).sampleData)
  return try! Images(JSON: jsonObject)
}
