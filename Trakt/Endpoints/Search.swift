/*
Copyright 2017 ArcTouch LLC.
All rights reserved.
 
This file, its contents, concepts, methods, behavior, and operation
(collectively the "Software") are protected by trade secret, patent,
and copyright laws. The use of the Software is governed by a license
agreement. Disclosure of the Software to third parties, in any form,
in whole or in part, is expressly prohibited except as authorized by
the license agreement.
*/

import Moya

public enum Search {
  case idLookup(idType: IDType, id: String, types: [SearchType], page: Int?, limit: Int?)
  case textQuery(types: [SearchType], query: String, page: Int?, limit: Int?)
}

extension Search: TraktType {

  public var path: String {
    switch self {
    case .idLookup(let idType, let id, _, _, _):
      return "search/\(idType.rawValue)/\(id)"
    case .textQuery(let types, _, _, _):
      let typesPath = types.map { $0.rawValue }.joined(separator: ",")
      return "search/\(typesPath)"
    }
  }

  public var parameters: [String: Any]? {
    switch self {
    case .idLookup(_, _, let types, let page, let limit):
      return ["type": types.map { $0.rawValue }.joined(separator: ","), "page": page ?? 0, "limit": limit ?? 10]
    case .textQuery(_, let query, let page, let limit):
      return ["query": query, "page": page ?? 0, "limit": limit ?? 10]
    }
  }

  public var sampleData: Data {
    let fileName: String

    if case .textQuery = self {
      fileName = "trakt_search_textquery"
    } else {
      fileName = "search_idlookup"
    }

    return stubbedResponse(fileName)
  }
}
