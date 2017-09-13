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
import TMDBSwift
import Moya_ObjectMapper

let configurationRepositoryMock = ConfigurationRepositoryMock(tmdbProvider: tmdbProviderMock)

final class ConfigurationRepositoryMock: ConfigurationRepository {
  private let provider: RxMoyaProvider<ConfigurationService>

  init(tmdbProvider: TMDBProvider) {
    self.provider = tmdbProvider.configuration
  }

  func fetchConfiguration() -> Observable<Configuration> {
    return provider.request(.configuration).mapObject(Configuration.self)
  }
}
