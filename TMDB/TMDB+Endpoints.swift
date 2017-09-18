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
import Result

extension TMDB {

  public var configuration: RxMoyaProvider<ConfigurationService> {
    return createProvider(forTarget: ConfigurationService.self)
  }

  public var movies: RxMoyaProvider<Movies> {
    return createProvider(forTarget: Movies.self)
  }

  public var shows: RxMoyaProvider<Shows> {
    return createProvider(forTarget: Shows.self)
  }

  private func createProvider<T: TMDBType>(forTarget target: T.Type) -> RxMoyaProvider<T> {
    var plugins = [PluginType]()

    plugins.append(NetworkLoggerPlugin())

    let requestClosure = createRequestClosure(forTarget: target)

    return RxMoyaProvider<T>(requestClosure: requestClosure, plugins: plugins)
  }

  private func createRequestClosure<T: TMDBType>(forTarget target: T.Type) -> MoyaProvider<T>.RequestClosure {
    let requestClosure = { (endpoint: Endpoint<T>, done: MoyaProvider.RequestResultClosure) in
      guard let url = endpoint.urlRequest?.url else {
        done(.failure(MoyaError.requestMapping(endpoint.url)))
        return
      }

      var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

      var queryItems = components?.queryItems ?? [URLQueryItem]()
      queryItems.append(URLQueryItem(name: "api_key", value: self.apiKey))
      components?.queryItems = queryItems

      var newRequest = endpoint.urlRequest
      newRequest?.url = components?.url

      guard let validRequest = newRequest else {
        done(.failure(MoyaError.requestMapping(endpoint.url)))
        return
      }

      done(.success(validRequest))
    }

    return requestClosure
  }
}
