import Moya

public enum Episodes {
  case summary(showId: String, season: Int, episode: Int, extended: Extended)
}

extension Episodes: TraktType {
  public var path: String {
    switch self {
    case .summary(let showId, let season, let episode, _):
      return "shows/\(showId)/seasons/\(season)/episodes/\(episode)"
    }
  }

  public var parameters: [String : Any]? {
    switch self {
    case .summary(_, _, _, let extended):
      return ["extended": extended.rawValue]
    }
  }

  public var sampleData: Data {
    switch self {
    case .summary:
      return stubbedResponse("trakt_episodes_summary")
    }
  }
}
