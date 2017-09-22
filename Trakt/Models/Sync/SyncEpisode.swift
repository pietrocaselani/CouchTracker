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

public struct SyncEpisode: ImmutableMappable {
  public let ids: EpisodeIds
  public let season, number: Int?
  public let watchedAt, collectedAt, ratedAt: Date?
  public let rating: Rating?
  
  public init(ids: EpisodeIds, season: Int? = nil, number: Int? = nil, watchedAt: Date? = nil,
              collectedAt: Date? = nil, ratedAt: Date? = nil, rating: Rating? = nil) {
    self.ids = ids
    self.watchedAt = watchedAt
    self.season = season
    self.number = number
    self.collectedAt = collectedAt
    self.ratedAt = ratedAt
    self.rating = rating
  }
  
  public init(map: Map) throws {
    self.ids = try map.value("ids")
    self.watchedAt = try? map.value("watched_at")
    self.season = try? map.value("season")
    self.collectedAt = try? map.value("collected_at")
    self.rating = try? map.value("rating")
    self.ratedAt = try? map.value("rated_at")
    self.number = try? map.value("number")
  }
  
  public func mapping(map: Map) {
    self.ids >>> map["ids"]
    self.watchedAt >>> map["watched_at"]
    self.season >>> map["season"]
    self.collectedAt >>> map["collected_at"]
    self.rating >>> map["rating"]
    self.ratedAt >>> map["rated_at"]
    self.number >>> map["number"]
  }  
}
