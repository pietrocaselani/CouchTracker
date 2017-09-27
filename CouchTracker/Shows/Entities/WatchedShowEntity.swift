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

struct WatchedShowEntity: Hashable {
  let show: ShowEntity
  let aired: Int
  let completed: Int
  let nextEpisode: EpisodeEntity?

  var hashValue: Int {
    var hash = show.hashValue ^ aired.hashValue ^ completed.hashValue

    if let nextEpisodeHash = nextEpisode?.hashValue {
      hash ^= nextEpisodeHash
    }

    return hash
  }

  static func == (lhs: WatchedShowEntity, rhs: WatchedShowEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
