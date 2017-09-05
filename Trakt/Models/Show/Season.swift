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

public final class Season: ImmutableMappable, Hashable {
  public let number: Int
  public let ids: SeasonIds
  public let overview: String?
  public let rating: Double?
  public let votes: Int?
  public let episodeCount: Int?
  public let airedEpisodes: Int?
  public let episodes: [Episode]?
  
  public init(map: Map) throws {
    self.number = try map.value("number")
    self.ids = try map.value("ids")
    self.overview = try? map.value("overview")
    self.rating = try? map.value("rating")
    self.votes = try? map.value("votes")
    self.episodeCount = try? map.value("episode_count")
    self.airedEpisodes = try? map.value("aired_episodes")
    self.episodes = try? map.value("episodes")
  }
  
  public var hashValue: Int {
    var hash = number.hashValue ^ ids.hashValue
    
    if let overviewHash = overview?.hashValue {
      hash = hash ^ overviewHash
    }
    
    if let ratingHash = rating?.hashValue {
      hash = hash ^ ratingHash
    }
    
    if let votesHash = votes?.hashValue {
      hash = hash ^ votesHash
    }
    
    if let episodeCounthash = episodeCount?.hashValue {
      hash = hash ^ episodeCounthash
    }
    
    if let airedEpisodesHash = airedEpisodes?.hashValue {
      hash = hash ^ airedEpisodesHash
    }
    
    episodes?.forEach { hash = hash ^ $0.hashValue }
    
    return hash
  }
  
  public static func == (lhs: Season, rhs: Season) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
