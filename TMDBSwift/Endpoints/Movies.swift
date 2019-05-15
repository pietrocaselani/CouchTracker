import Moya

public enum Movies {
  case images(movieId: Int)
}

extension Movies: TMDBType {
  public var path: String {
    switch self {
    case let .images(movieId):
      return "movie/\(movieId)/images"
    }
  }

  public var task: Task {
    return .requestPlain
  }

  public var sampleData: Data {
    switch self {
    case let .images(movieId):
      guard movieId == 20526 else {
        return stubbedResponse("tmdb_movie_images")
      }
      return stubbedResponse("tmdb_movie_images_20526")
    }
  }
}
