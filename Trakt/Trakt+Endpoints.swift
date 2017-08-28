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

extension Trakt {
  public var movies: RxMoyaProvider<Movies> {
    return createProvider(forTarget: Movies.self)
  }

  public var genres: RxMoyaProvider<Genres> {
    return createProvider(forTarget: Genres.self)
  }

  public var search: RxMoyaProvider<Search> {
    return createProvider(forTarget: Search.self)
  }

  private func createProvider<T: TraktType>(forTarget target: T.Type) -> RxMoyaProvider<T> {
    let endpointClosure = createEndpointClosure(forTarget: target)

    var plugins = [PluginType]()

    #if DEBUG
      plugins.append(NetworkLoggerPlugin())
    #endif

    return RxMoyaProvider<T>(endpointClosure: endpointClosure, plugins: plugins)
  }

  private func createEndpointClosure<T: TargetType>(forTarget: T.Type) -> MoyaProvider<T>.EndpointClosure {
    return { (target: T) -> Endpoint<T> in
      var endpoint = MoyaProvider.defaultEndpointMapping(for: target)
      endpoint = endpoint.adding(newHTTPHeaderFields: [Trakt.headerContentType: Trakt.contentTypeJSON])
      endpoint = endpoint.adding(newHTTPHeaderFields: [Trakt.headerTraktAPIKey: self.clientId])
      endpoint = endpoint.adding(newHTTPHeaderFields: [Trakt.headerTraktAPIVersion: Trakt.apiVersion])

      return endpoint
    }
  }
}
