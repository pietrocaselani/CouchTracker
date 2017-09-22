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
