import Moya

public enum Movies {
  case images(movieId: Int)
}

extension Movies: TMDBType {
  public var path: String {
    switch self {
    case .images(let movieId):
      return "movie/\(movieId)/images"
    }
  }

  public var parameters: [String: Any]? {
    return nil
  }

  public var sampleData: Data {
    switch self {
    case .images(let movieId):
      guard movieId == 20526 else {
        return stubbedResponse("tmdb_movie_images")
      }
      return stubbedResponse("tmdb_movie_images_20526")
    }
  }
}
