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

struct ImagesEntity: Hashable {
  public let identifier: Int
  public let backdrops: [ImageEntity]
  public let posters: [ImageEntity]

  func bestImage() -> ImageEntity? {
    return bestPosterImage() ?? bestBackdropImage()
  }

  func bestPosterImage() -> ImageEntity? {
    return posters.first
  }

  func bestBackdropImage() -> ImageEntity? {
    return backdrops.first
  }

  var hashValue: Int {
    var hash = identifier.hashValue
    backdrops.forEach { hash = hash ^ $0.hashValue }
    posters.forEach { hash = hash ^ $0.hashValue }
    return hash
  }

  static func == (lhs: ImagesEntity, rhs: ImagesEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}