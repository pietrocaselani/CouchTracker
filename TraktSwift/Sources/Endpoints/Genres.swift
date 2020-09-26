//import Moya
//
//public enum Genres {
//  case list(GenreType)
//}
//
//extension Genres: TraktType {
//  public var path: String {
//    switch self {
//    case let .list(mediaType):
//      return "genres/\(mediaType.rawValue)"
//    }
//  }
//
//  public var sampleData: Data {
//    switch self {
//    case let .list(type):
//      return stubbedResponse("trakt_genres_\(type)")
//    }
//  }
//}
