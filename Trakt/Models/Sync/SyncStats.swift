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

public struct SyncStats: ImmutableMappable {
  public let movies, shows, seasons, episodes: Int?
  
  public init(movies: Int?, shows: Int?, seasons: Int?, episodes: Int?) {
    self.movies = movies
    self.shows = shows
    self.seasons = seasons
    self.episodes = episodes
  }
  
  public init(map: Map) throws {
    self.movies = try? map.value("movies")
    self.shows = try? map.value("shows")
    self.seasons = try? map.value("seasons")
    self.episodes = try? map.value("episodes")
  }
  
  public func mapping(map: Map) {
    self.movies >>> map["movies"]
    self.shows >>> map["shows"]
    self.seasons >>> map["seasons"]
    self.episodes >>> map["episodes"]
  }
}
