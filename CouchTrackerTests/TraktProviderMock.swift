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
import TraktSwift
import RxSwift

let traktProviderMock = TraktProviderMock()

final class TraktProviderMock: TraktProvider {
  private let error: Swift.Error?

  func finishesAuthentication(with request: URLRequest) -> Observable<AuthenticationResult> {
    guard let error = error else {
      let result = oauth != nil ? AuthenticationResult.authenticated : AuthenticationResult.undetermined
      return Observable.just(result)
    }

    return Observable.error(error)
  }

  var oauth: URL?

  var movies: RxMoyaProvider<Movies> {
    return RxMoyaProvider<Movies>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var genres: RxMoyaProvider<Genres> {
    return RxMoyaProvider<Genres>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var search: RxMoyaProvider<Search> {
    return RxMoyaProvider<Search>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var shows: RxMoyaProvider<Shows> {
    return RxMoyaProvider<Shows>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var users: RxMoyaProvider<Users> {
    return RxMoyaProvider<Users>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var authentication: RxMoyaProvider<Authentication> {
    return RxMoyaProvider<Authentication>(stubClosure: MoyaProvider.immediatelyStub)
  }

  var isAuthenticated: Bool {
    return oauth != nil
  }

  init(oauthURL: URL? = nil, error: Swift.Error? = nil) {
    self.oauth = oauthURL
    self.error = error
  }
}
