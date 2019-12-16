import Moya

public final class TMDB {
  let apiKey: String

  public lazy var configuration = createProvider(forTarget: ConfigurationService.self)
  public lazy var movies = createProvider(forTarget: Movies.self)
  public lazy var shows = createProvider(forTarget: Shows.self)
  public lazy var episodes = createProvider(forTarget: Episodes.self)

  public init(apiKey: String) {
    self.apiKey = apiKey
  }

  private func createProvider<T: TMDBType>(forTarget target: T.Type) -> MoyaProvider<T> {
    let requestClosure = createRequestClosure(forTarget: target)

    return MoyaProvider<T>(requestClosure: requestClosure)
  }

  private func createRequestClosure<T: TMDBType>(forTarget _: T.Type) -> MoyaProvider<T>.RequestClosure {
    let requestClosure = { (endpoint: Endpoint, done: MoyaProvider<T>.RequestResultClosure) in
      guard let request = try? endpoint.urlRequest(), let url = request.url else {
        done(.failure(MoyaError.requestMapping(endpoint.url)))
        return
      }

      var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

      var queryItems = components?.queryItems ?? [URLQueryItem]()
      queryItems.append(URLQueryItem(name: "api_key", value: self.apiKey))
      components?.queryItems = queryItems

      guard let newURL = components?.url else {
        done(.failure(MoyaError.requestMapping(endpoint.url)))
        return
      }

      var newRequest = request
      newRequest.url = newURL

      done(.success(newRequest))
    }

    return requestClosure
  }
}
