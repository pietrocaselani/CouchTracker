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

public final class BaseSeason: ImmutableMappable, Hashable {
  public let number: Int
  public let episodes: [BaseEpisode]
  public let aired: Int?
  public let completed: Int?

  public init(map: Map) throws {
    self.number = try map.value("number")
    self.episodes = try map.value("episodes")
    self.aired = try? map.value("aired")
    self.completed = try? map.value("completed")
  }
  
  public var hashValue: Int {
    var hash = number.hashValue

    if let airedHash = aired?.hashValue {
      hash = hash ^ airedHash
    }

    if let completedHash = completed?.hashValue {
      hash = hash ^ completedHash
    }

    episodes.forEach { hash = hash ^ $0.hashValue }

    return hash
  }

  public static func ==(lhs: BaseSeason, rhs: BaseSeason) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
