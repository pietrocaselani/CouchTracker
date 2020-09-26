//import Moya
//
//public enum Episodes {
//  case summary(showId: String, season: Int, episode: Int, extended: Extended)
//}
//
//extension Episodes: TraktType {
//  public var path: String {
//    switch self {
//    case .summary(let showId, let season, let episode, _):
//      return "shows/\(showId)/seasons/\(season)/episodes/\(episode)"
//    }
//  }
//
//  public var task: Task {
//    switch self {
//    case let .summary(_, _, _, extended):
//      return .requestParameters(parameters: ["extended": extended.rawValue], encoding: URLEncoding.default)
//    }
//  }
//
//  public var sampleData: Data {
//    switch self {
//    case .summary:
//      return stubbedResponse("trakt_episodes_summary")
//    }
//  }
//}
