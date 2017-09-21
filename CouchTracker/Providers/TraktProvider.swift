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
import RxSwift
import TraktSwift

protocol TraktProvider: class {
  var movies: RxMoyaProvider<Movies> { get }
  var genres: RxMoyaProvider<Genres> { get }
  var search: RxMoyaProvider<Search> { get }
  var shows: RxMoyaProvider<Shows> { get }
  var users: RxMoyaProvider<Users> { get }
  var authentication: RxMoyaProvider<Authentication> { get }
  var episodes: RxMoyaProvider<Episodes> { get }
  var sync: RxMoyaProvider<Sync> { get }
  var oauth: URL? { get }
  var isAuthenticated: Bool { get }

  func finishesAuthentication(with request: URLRequest) -> Observable<AuthenticationResult>
}
