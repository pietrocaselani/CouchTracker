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

public struct SyncItems: ImmutableMappable {
  public let movies: [SyncMovie]?
  public let shows: [SyncShow]?
  public let episodes: [SyncEpisode]?
  public let ids: [Int]?
  
  public init(movies: [SyncMovie]? = nil, shows: [SyncShow]? = nil, episodes: [SyncEpisode]? = nil, ids: [Int]? = nil) {
    self.movies = movies
    self.shows = shows
    self.episodes = episodes
    self.ids = ids
  }
  
  public init(map: Map) throws {
    self.movies = try? map.value("movies")
    self.shows = try? map.value("shows")
    self.episodes = try? map.value("episodes")
    self.ids = try? map.value("ids")
  }
  
  public func mapping(map: Map) {
    self.movies >>> map["movies"]
    self.shows >>> map["shows"]
    self.episodes >>> map["episodes"]
    self.ids >>> map["ids"]
  }  
}
