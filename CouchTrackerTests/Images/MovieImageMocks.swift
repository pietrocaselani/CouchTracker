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

import TMDB_Swift
import RxSwift

let imageRepositoryRealMock = ImageRepositoryMock(tmdbProvider: tmdbProviderMock, cofigurationRepository: configurationRepositoryMock)
let imageRepositoryMock = EmptyImageRepositoryMock(tmdbProvider: tmdbProviderMock, cofigurationRepository: configurationRepositoryMock)

final class ErrorImageRepositoryMock: ImageRepository {
  private var error: Error!

  convenience init(error: Error) {
    self.init(tmdbProvider: tmdbProviderMock, cofigurationRepository: configurationRepositoryMock)
    self.error = error
  }

  init(tmdbProvider: TMDBProvider, cofigurationRepository: ConfigurationRepository) {}

  func fetchImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Observable<ImagesEntity> {
    return Observable.error(error)
  }
}

func createMovieImagesRepositoryMock(_ images: ImagesEntity) -> ImageRepository {
  return ImagesRepositorySampleMock(tmdbProvider: tmdbProviderMock, cofigurationRepository: configurationRepositoryMock, images: images)
}

func createTMDBConfigurationMock() -> Configuration {
  let jsonObject = parseToJSONObject(data: ConfigurationService.configuration.sampleData)
  return try! Configuration(JSON: jsonObject)
}

func createImagesMock(movieId: Int) -> Images {
  let jsonObject = parseToJSONObject(data: Movies.images(movieId: movieId).sampleData)
  return try! Images(JSON: jsonObject)
}
