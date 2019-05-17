import Moya

public enum Shows {
  case images(showId: Int)
}

extension Shows: TMDBType {
  public var path: String {
    switch self {
    case let .images(showId):
      return "tv/\(showId)/images"
    }
  }

  public var task: Task {
    return .requestPlain
  }

  public var sampleData: Data {
    switch self {
    case .images:
      return stubbedResponse("tmdb_show_images")
    }
  }
}
