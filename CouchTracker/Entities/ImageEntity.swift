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

struct ImageEntity: Hashable {
  let link: String
  let width: Int
  let height: Int
  let iso6391: String?
  let aspectRatio: Float
  let voteAverage: Float
  let voteCount: Int

  func isBest(then: ImageEntity) -> Bool {
    return self.voteCount < then.voteCount
  }

  var hashValue: Int {
    var hash = link.hashValue
    hash = hash ^ width.hashValue
    hash = hash ^ height.hashValue

    if let iso6391Hash = iso6391?.hashValue {
      hash = hash ^ iso6391Hash
    }

    hash = hash ^ aspectRatio.hashValue
    hash = hash ^ voteAverage.hashValue
    hash = hash ^ voteCount.hashValue

    return hash
  }

  static func == (lhs: ImageEntity, rhs: ImageEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
