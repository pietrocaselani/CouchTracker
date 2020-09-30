import HTTPClient

public struct MoviesService {
  public let trending: (TrendingMoviesParameters) -> APICallPublisher<[TrendingMovie]>
}

public extension MoviesService {
  struct TrendingMoviesParameters {
    public let page, limit: Int
    /**
     Only accepts .default or .full for Extended
     */
    public let extended: Extended

    public init(page: Int, limit: Int, extended: Extended) {
      self.page = page
      self.limit = limit
      self.extended = extended
    }
  }
}

extension MoviesService {
  static func from(apiClient: APIClient) -> Self {
    .init(
      trending: { params in
        apiClient.get(
          .init(
            path: "movies/trending",
            queryItems: [
              .init(name: "page", value: String(params.page)),
              .init(name: "limit", value: String(params.limit)),
              .init(name: "extended", value: params.extended.rawValue)
            ]
          )
        ).decoded(as: [TrendingMovie].self)
      }
    )
  }
}

//import Moya
//
//public enum Movies {
//  /**
//   Only accepts .default or .full for Extended
//   */
//  case summary(movieId: String, extended: Extended)
//}
//
//extension Movies: TraktType {
//  public var path: String {
//    switch self {
//    case .trending:
//      return "movies/trending"
//    case .summary(let movieId, _):
//      return "movies/\(movieId)"
//    }
//  }
//
//  public var task: Task {
//    let params: [String: Any]
//    switch self {
//    case let .trending(page, limit, extended):
//      params = ["page": page, "limit": limit, "extended": extended.rawValue]
//    case let .summary(_, extended):
//      params = ["extended": extended.rawValue]
//    }
//
//    return .requestParameters(parameters: params, encoding: URLEncoding.default)
//  }
//
//  public var sampleData: Data {
//    switch self {
//    case .trending:
//      return stubbedResponse("trakt_movies_trending")
//    case .summary:
//      return stubbedResponse("trakt_movies_summary")
//    }
//  }
//}
