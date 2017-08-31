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

public enum Genres {
  case list(GenreType)
}

extension Genres: TraktType {

  public var path: String {
    switch self {
    case .list(let mediaType):
      return "genres/\(mediaType.rawValue)"
    }
  }

  public var parameters: [String: Any]? {
    return nil
  }

  public var sampleData: Data {
    switch self {
    case .list(let type):
      return stubbedResponse("trakt_genres_\(type)")
    }
  }
}
