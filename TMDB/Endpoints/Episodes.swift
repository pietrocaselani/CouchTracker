import Moya

public enum Episodes {
  case images(showId: Int, season: Int, episode: Int)
}

extension Episodes: TMDBType {
  public var path: String {
    switch self {
    case .images(let showId, let season, let episode):
      return "tv/\(showId)/season/\(season)/episode/\(episode)/images"
    }
  }

  public var parameters: [String : Any]? { return nil }

  public var sampleData: Data {
    switch self {
    case .images:
      return stubbedResponse("tmdb_episode_images")
    }
  }
}
