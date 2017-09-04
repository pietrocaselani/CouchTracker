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

struct SearchResultViewModel {
  let type: SearchType
  let movie: MovieViewModel?
}

extension SearchResultViewModel: Hashable {
  var hashValue: Int {
    var hash = type.hashValue

    if let movieHash = movie?.hashValue {
      hash ^= movieHash
    }

    return hash
  }

  static func == (lhs: SearchResultViewModel, rhs: SearchResultViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
