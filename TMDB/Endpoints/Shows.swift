import Moya

public enum Shows {
  case images(showId: Int)
}

extension Shows: TMDBType {
  public var path: String {
    switch self {
    case .images(let showId):
      return "tv/\(showId)/images"
    }
  }

  public var parameters: [String : Any]? { return nil }

  public var sampleData: Data {
    switch self {
    case .images:
      return stubbedResponse("tmdb_show_images")
    }
  }
}
