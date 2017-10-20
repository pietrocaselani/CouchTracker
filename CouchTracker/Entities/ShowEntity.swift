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

import TraktSwift
import Foundation

struct ShowEntity: Hashable {
  let ids: ShowIds
  let title: String?
  let overview: String?
  let network: String?
  let genres: [Genre]?
  let status: Status?
  let firstAired: Date?

  var hashValue: Int {
    var hash = ids.hashValue

    if let titleHash = title?.hashValue {
      hash = hash ^ titleHash
    }

    if let overviewHash = overview?.hashValue {
      hash = hash ^ overviewHash
    }

    if let statusHash = status?.hashValue {
      hash = hash ^ statusHash
    }

    if let firstAiredHash = firstAired?.hashValue {
      hash = hash ^ firstAiredHash
    }

    if let networkHash = network?.hashValue {
      hash = hash ^ networkHash
    }

    genres?.forEach { hash = hash ^ $0.hashValue }

    return hash
  }

  static func == (lhs: ShowEntity, rhs: ShowEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
