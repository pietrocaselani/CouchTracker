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
import Foundation

struct MovieEntity: Hashable {
  let ids: MovieIds
  let title: String?
  let genres: [Genre]?
  let tagline: String?
  let overview: String?
  let releaseDate: Date?

  var hashValue: Int {
    var hash = ids.hashValue

    if let titleHash = title?.hashValue {
      hash = hash ^ titleHash
    }

    if let taglineHash = tagline?.hashValue {
      hash = hash ^ taglineHash
    }

    if let overviewHash = overview?.hashValue {
      hash = hash ^ overviewHash
    }

    if let releaseDateHash = releaseDate?.hashValue {
      hash = hash ^ releaseDateHash
    }

    genres?.forEach { hash = hash ^ $0.hashValue }

    return hash
  }

  static func == (lhs: MovieEntity, rhs: MovieEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
