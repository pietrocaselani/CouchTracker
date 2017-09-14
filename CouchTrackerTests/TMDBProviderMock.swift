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

import Moya
import TMDB_Swift

let tmdbProviderMock = TMDBProviderMock()

final class TMDBProviderMock: TMDBProvider {
  var movies: RxMoyaProvider<Movies> {
    return RxMoyaProvider<Movies>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var shows: RxMoyaProvider<Shows> {
    return RxMoyaProvider<Shows>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var configuration: RxMoyaProvider<ConfigurationService> {
    return RxMoyaProvider<ConfigurationService>(stubClosure: MoyaProvider.immediatelyStub)
  }
}
