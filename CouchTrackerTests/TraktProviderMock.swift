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
import Trakt_Swift

let traktProviderMock = TraktProviderMock()

final class TraktProviderMock: TraktProvider {

  var movies: RxMoyaProvider<Movies> {
    return RxMoyaProvider<Movies>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var genres: RxMoyaProvider<Genres> {
    return RxMoyaProvider<Genres>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var search: RxMoyaProvider<Search> {
    return RxMoyaProvider<Search>(stubClosure: MoyaProvider.immediatelyStub)
  }

}
