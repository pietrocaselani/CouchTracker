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

import TMDBSwift

extension Movies: Hashable {
  public var hashValue: Int {
    switch self {
    case .images(let movieId):
      return self.path.hashValue ^ movieId.hashValue
    }
  }

  public static func == (lhs: Movies, rhs: Movies) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
