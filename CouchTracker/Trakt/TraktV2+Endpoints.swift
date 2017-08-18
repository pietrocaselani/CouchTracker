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

extension TraktV2 {

  public var movies: RxMoyaProvider<Movies> {
    return createProvider(forTarget: Movies.self)
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
    let endpointClosure = { (target: T) -> Endpoint<T> in
      var endpoint = MoyaProvider.defaultEndpointMapping(for: target)
      endpoint = endpoint.adding(newHTTPHeaderFields: [TraktV2.headerContentType: TraktV2.contentTypeJSON])
      endpoint = endpoint.adding(newHTTPHeaderFields: [TraktV2.headerTraktAPIKey: self.clientId])
      endpoint = endpoint.adding(newHTTPHeaderFields: [TraktV2.headerTraktAPIVersion: TraktV2.apiVersion])

      return endpoint
    }

    return endpointClosure
  }

}
