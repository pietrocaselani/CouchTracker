import Moya

public enum Movies {
  /**
   Only accepts .default or .full for Extended
   */
  case trending(page: Int, limit: Int, extended: Extended)
  /**
   Only accepts .default or .full for Extended
   */
  case summary(movieId: String, extended: Extended)
}

extension Movies: TraktType {
  public var path: String {
    switch self {
    case .trending:
      return "movies/trending"
    case .summary(let movieId, _):
      return "movies/\(movieId)"
    }
  }

  public var task: Task {
    let params: [String: Any]
    switch self {
    case let .trending(page, limit, extended):
      params = ["page": page, "limit": limit, "extended": extended.rawValue]
    case let .summary(_, extended):
      params = ["extended": extended.rawValue]
    }

    return .requestParameters(parameters: params, encoding: URLEncoding.default)
  }

  public var sampleData: Data {
    switch self {
    case .trending:
      return stubbedResponse("trakt_movies_trending")
    case .summary:
      return stubbedResponse("trakt_movies_summary")
    }
  }
}
