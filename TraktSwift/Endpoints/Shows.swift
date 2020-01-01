import Moya

public enum Shows {
  /**
   Only accepts .default or .full for Extended
   */
  case trending(page: Int, limit: Int, extended: Extended)
  /**
   Only accepts .default or .full for Extended
   */
  case popular(page: Int, limit: Int, extended: Extended)
  /**
   Only accepts .default or .full for Extended
   */
  case played(period: Period, page: Int, limit: Int, extended: Extended)
  /**
   Only accepts .default or .full for Extended
   */
  case watched(period: Period, page: Int, limit: Int, extended: Extended)
  /**
   Only accepts .default or .full for Extended
   */
  case collected(period: Period, page: Int, limit: Int, extended: Extended)
  /**
   Only accepts .default or .full for Extended
   */
  case anticipated(page: Int, limit: Int, extended: Extended)
  /**
   Only accepts .default or .full for Extended
   */
  case summary(showId: String, extended: Extended)
  case watchedProgress(showId: String, hidden: Bool, specials: Bool, countSpecials: Bool)
}

extension Shows: TraktType {
  public var path: String {
    switch self {
    case .trending:
      return "/shows/trending"
    case .popular:
      return "/shows/popular"
    case .played(let period, _, _, _):
      return "/shows/played/\(period)"
    case .watched(let period, _, _, _):
      return "/shows/watched/\(period)"
    case .collected(let period, _, _, _):
      return "/shows/collected/\(period)"
    case .anticipated:
      return "/shows/anticipated"
    case .summary(let showId, _):
      return "/shows/\(showId)"
    case .watchedProgress(let showId, _, _, _):
      return "/shows/\(showId)/progress/watched"
    }
  }

  public var task: Task {
    let params: [String: Any]
    switch self {
    case let .trending(page, limit, extended),
         let .popular(page, limit, extended),
         let .played(_, page, limit, extended),
         let .watched(_, page, limit, extended),
         let .collected(_, page, limit, extended),
         let .anticipated(page, limit, extended):
      params = ["page": page, "limit": limit, "extended": extended.rawValue]
    case let .summary(_, extended):
      params = ["extended": extended.rawValue]
    case let .watchedProgress(_, hidden, specials, countSpecials):
      params = ["hidden": hidden, "specials": specials, "count_specials": countSpecials]
    }

    return .requestParameters(parameters: params, encoding: URLEncoding.default)
  }

  public var authorizationType: AuthorizationType? {
    switch self {
    case .watchedProgress: return .bearer
    default: return nil
    }
  }

  public var sampleData: Data {
    switch self {
    case .trending:
      return stubbedResponse("trakt_shows_trending")
    case .summary:
      return stubbedResponse("trakt_shows_summary")
    case .watchedProgress:
      return stubbedResponse("trakt_shows_watchedprogress")
    default:
      return Data()
    }
  }
}
