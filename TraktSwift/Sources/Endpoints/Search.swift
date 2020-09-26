//import Moya
//
//public enum Search {
//  case idLookup(idType: IDType, id: String, types: [SearchType], page: Int?, limit: Int?)
//  case textQuery(types: [SearchType], query: String, page: Int?, limit: Int?)
//}
//
//extension Search: TraktType {
//  public var path: String {
//    switch self {
//    case .idLookup(let idType, let id, _, _, _):
//      return "search/\(idType.rawValue)/\(id)"
//    case .textQuery(let types, _, _, _):
//      let typesPath = types.map { $0.rawValue }.joined(separator: ",")
//      return "search/\(typesPath)"
//    }
//  }
//
//  public var task: Task {
//    let params: [String: Any]
//
//    switch self {
//    case let .idLookup(_, _, types, page, limit):
//      params = ["type": types.map { $0.rawValue }.joined(separator: ","), "page": page ?? 0, "limit": limit ?? 10]
//    case let .textQuery(_, query, page, limit):
//      params = ["query": query, "page": page ?? 0, "limit": limit ?? 10]
//    }
//
//    return .requestParameters(parameters: params, encoding: URLEncoding.default)
//  }
//
//  public var sampleData: Data {
//    let fileName: String
//
//    if case let .textQuery(_, query, _, _) = self {
//      guard query != "empty" else { return "[]".data(using: .utf8) ?? Data() }
//
//      fileName = "trakt_search_textquery"
//    } else {
//      fileName = "search_idlookup"
//    }
//
//    return stubbedResponse(fileName)
//  }
//}
