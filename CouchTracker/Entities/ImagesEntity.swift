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
  public let stills: [ImageEntity]

  func posterImage() -> ImageEntity? {
    return bestImage(of: posters)
  }

  func backdropImage() -> ImageEntity? {
    return bestImage(of: backdrops)
  }

  func stillImage() -> ImageEntity? {
    let x = bestImage(of: stills)
    return x
  }

  private func bestImage(of images: [ImageEntity]) -> ImageEntity? {
    return images.max(by: { (lhs, rhs) -> Bool in
      return lhs.isBest(then: rhs)
    })
  }

  var hashValue: Int {
    var hash = identifier.hashValue
    backdrops.forEach { hash = hash ^ $0.hashValue }
    posters.forEach { hash = hash ^ $0.hashValue }
    stills.forEach { hash = hash ^ $0.hashValue }
    return hash
  }

  static func == (lhs: ImagesEntity, rhs: ImagesEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
