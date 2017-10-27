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

  public var episodes: RxMoyaProvider<Episodes> {
    return createProvider(forTarget: Episodes.self)
  }

  private func createProvider<T: TMDBType>(forTarget target: T.Type) -> RxMoyaProvider<T> {
    let plugins = [PluginType]()

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
