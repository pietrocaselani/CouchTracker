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

public struct SyncMovie: ImmutableMappable {
  public let ids: MovieIds
  public let watchedAt, collectedAt, ratedAt: Date?
  public let rating: Rating?
  
  public init(ids: MovieIds, watchedAt: Date?, collectedAt: Date?, ratedAt: Date?, rating: Rating?) {
    self.ids = ids
    self.watchedAt = watchedAt
    self.collectedAt = collectedAt
    self.ratedAt = ratedAt
    self.rating = rating
  }
  
  public init(map: Map) throws {
    self.ids = try map.value("ids")
    self.watchedAt = try? map.value("watched_at")
    self.collectedAt = try? map.value("collected_at")
    self.rating = try? map.value("rating")
    self.ratedAt = try? map.value("rated_at")
  }
  
  public func mapping(map: Map) {
    self.ids >>> map["ids"]
    self.watchedAt >>> map["watched_at"]
    self.collectedAt >>> map["collected_at"]
    self.rating >>> map["rating"]
    self.ratedAt >>> map["rated_at"]
  }
}
