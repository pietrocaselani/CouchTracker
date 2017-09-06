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

enum TrendingViewModelType: Hashable {
  case show(tmdbShowId: Int)
  case movie(tmdbMovieId: Int)

  var hashValue: Int {
    switch self {
    case .movie(let tmdbMovieId):
      return "movie".hashValue ^ tmdbMovieId.hashValue
    case .show(let tmdbShowId):
      return "show".hashValue ^ tmdbShowId.hashValue
    }
  }

  static func == (lhs: TrendingViewModelType, rhs: TrendingViewModelType) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

struct TrendingViewModel: Hashable {
  let title: String
  let type: TrendingViewModelType?

  static func == (lhs: TrendingViewModel, rhs: TrendingViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  var hashValue: Int {
    var hash = title.hashValue

    if let typeHash = type?.hashValue {
      hash = hash ^ typeHash
    }

    return hash
  }
}
