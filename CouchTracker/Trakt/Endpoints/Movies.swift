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

public enum Movies {
  case trending(page: Int, limit: Int, extended: Extended)
}

extension Movies: TraktType {

  public var path: String {
    switch self {
    case .trending:
      return "movies/trending"
    }
  }

  public var parameters: [String: Any]? {
    switch self {
    case .trending(let page, let limit, let extended):
      return ["page": page, "limit": limit, "extended": extended.rawValue]
    }
  }

  public var sampleData: Data {
    switch self {
    case .trending:
      // swiftlint:disable line_length
      return "[{\"watchers\": 21,\"movie\": {\"title\": \"TRON: Legacy\",\"year\": 2010,\"ids\": {\"trakt\": 1,\"slug\": \"tron-legacy-2010\",\"imdb\": \"tt1104001\",\"tmdb\": 20526}}},{\"watchers\": 17,\"movie\": {\"title\": \"The Dark Knight\",\"year\": 2008,\"ids\": {\"trakt\": 4,\"slug\": \"the-dark-knight-2008\",\"imdb\": \"tt0468569\",\"tmdb\": 155}}}]".utf8Encoded
    }
  }

}
