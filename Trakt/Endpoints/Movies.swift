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
  case summary(movieId: String, extended: Extended)
}

extension Movies: TraktType {

  public var path: String {
    switch self {
    case .trending:
      return "movies/trending"
    case .summary(let movieId, _):
      return "movies/\(movieId)"
    }
  }

  public var parameters: [String: Any]? {
    switch self {
    case .trending(let page, let limit, let extended):
      return ["page": page, "limit": limit, "extended": extended.rawValue]
    case .summary(_, let extended):
      return ["extended": extended.rawValue]
    }
  }

  public var sampleData: Data {
    switch self {
    case .trending:
      // swiftlint:disable line_length
      return "[{\"watchers\":21,\"movie\":{\"title\":\"TRON:Legacy\",\"year\":2010,\"ids\":{\"trakt\":1,\"slug\":\"tron-legacy-2010\",\"imdb\":\"tt1104001\",\"tmdb\":20526}}},{\"watchers\":17,\"movie\":{\"title\":\"TheDarkKnight\",\"year\":2008,\"ids\":{\"trakt\":4,\"slug\":\"the-dark-knight-2008\",\"imdb\":\"tt0468569\",\"tmdb\":155}}},{\"watchers\":2,\"movie\":{\"title\":null,\"year\":1992,\"ids\":{\"trakt\":23,\"slug\":\"1992-23\",\"imdb\":\"tt0468569\",\"tmdb\":155}}}]".utf8Encoded
    case .summary:
      // swiftlint: disable line_length
      return "{  \"title\": \"TRON: Legacy\",  \"year\": 2010,  \"ids\": {    \"trakt\": 343,    \"slug\": \"tron-legacy-2010\",    \"imdb\": \"tt1104001\",    \"tmdb\": 20526  },  \"tagline\": \"The Game Has Changed.\",  \"overview\": \"Sam Flynn, the tech-savvy and daring son of Kevin Flynn, investigates his father's disappearance and is pulled into The Grid. With the help of  a mysterious program named Quorra, Sam quests to stop evil dictator Clu from crossing into the real world.\",  \"released\": \"2010-12-16\",  \"runtime\": 125,  \"updated_at\": \"2014-07-23T03:21:46.000Z\",  \"trailer\": null,  \"homepage\": \"http://disney.go.com/tron/\",  \"rating\": 8,  \"votes\": 111,  \"language\": \"en\",  \"available_translations\": [    \"en\"  ],  \"genres\": [    \"action\"  ],  \"certification\": \"PG-13\"}".utf8Encoded
    }
  }

}
