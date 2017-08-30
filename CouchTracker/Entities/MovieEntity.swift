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

import Trakt_Swift

struct MovieEntity: Hashable {
  let ids: MovieIds
  let title: String?
  let images: ImagesEntity

  var hashValue: Int {
    var hash = ids.hashValue

    if let titleHash = title?.hashValue {
      hash = hash ^ titleHash
    }

    hash = hash ^ images.hashValue

    return hash
  }

  static func == (lhs: MovieEntity, rhs: MovieEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
