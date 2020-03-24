import Moya

public enum Seasons {
  /**
   Accepts, .default, .full,  and .episodes for Extended
   */
  case summary(showId: String, extended: [Extended])

  /**
   Accepts, .default, .full,  and .episodes for Extended
   */
  case single(showId: String, season: Int, extended: [Extended])
}

extension Seasons: TraktType {
  public var path: String {
    switch self {
    case .summary(let showId, _):
      return "/shows/\(showId)/seasons"
    case let .single(showId, season, _):
      return "shows/\(showId)/seasons/\(season)"
    }
  }

  public var task: Task {
    switch self {
    case let .summary(_, extended):
      return .requestParameters(parameters: ["extended": extended.separatedByComma()], encoding: URLEncoding.default)
    case let .single(_, _, extended):
      return .requestParameters(parameters: ["extended": extended.separatedByComma()], encoding: URLEncoding.default)
    }
  }

  public var sampleData: Data {
    switch self {
    case .summary: return stubbedResponse("trakt_seasons_summary")
    case .single: return Data()
    }
  }
}
