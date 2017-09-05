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

public final class SeasonIds: ImmutableMappable, Hashable {
  public let tvdb: Int
  public let tmdb: Int
  public let trakt: Int
  public let tvrage: Int?
  
  public required init(map: Map) throws {
    self.tvdb = try map.value("tvdb")
    self.tmdb = try map.value("tmdb")
    self.trakt = try map.value("trakt")
    self.tvrage = try? map.value("tvrage")
  }
  
  public func mapping(map: Map) {
    self.tvdb >>> map["tvdb"]
    self.tmdb >>> map["tmdb"]
    self.trakt >>> map["trakt"]
    self.tvrage >>> map["tvrage"]
  }
  
  public var hashValue: Int {
    var hash = tvdb.hashValue ^ tmdb.hashValue ^ trakt.hashValue
    if let tvrageHash = tvrage?.hashValue {
      hash = hash ^ tvrageHash
    }
    
    return hash
  }
  
  public static func == (lhs: SeasonIds, rhs: SeasonIds) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
