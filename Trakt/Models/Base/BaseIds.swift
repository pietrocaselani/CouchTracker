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

import ObjectMapper

public class BaseIds: ImmutableMappable, Hashable {
  public let trakt: Int
  public let tmdb: Int?
  public let imdb: String?

  public required init(map: Map) throws {
    self.trakt = try map.value("trakt")
    self.tmdb = try? map.value("tmdb")
    self.imdb = try? map.value("imdb")
  }

  public func mapping(map: Map) {
    self.trakt >>> map["trakt"]
    self.tmdb >>> map["tmdb"]
    self.imdb >>> map["imdb"]
  }

  public var hashValue: Int {
    var hash = trakt.hashValue

    if let tmdbHash = tmdb?.hashValue {
      hash = hash ^ tmdbHash
    }

    if let imdbHash = imdb?.hashValue {
      hash = hash ^ imdbHash
    }

    return hash
  }

  public static func == (lhs: BaseIds, rhs: BaseIds) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
