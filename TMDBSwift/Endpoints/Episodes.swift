import Moya

public enum Episodes {
  case images(showId: Int, season: Int, episode: Int)
}

extension Episodes: TMDBType {
  public var path: String {
    switch self {
    case let .images(showId, season, episode):
      return "tv/\(showId)/season/\(season)/episode/\(episode)/images"
    }
  }

  public var task: Task {
    return .requestPlain
  }

  public var sampleData: Data {
    switch self {
    case .images:
      return stubbedResponse("tmdb_episode_images")
    }
  }
}
