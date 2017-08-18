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

import ObjectMapper

public final class TrendingMovie: BaseTrendingEntity {

  public let movie: Movie

  public required init(map: Map) throws {
    self.movie = try map.value("movie")

    try super.init(map: map)
  }

}

extension TrendingMovie: Equatable, Hashable {

  public static func == (lhs: TrendingMovie, rhs: TrendingMovie) -> Bool {
    return lhs.movie == rhs.movie
  }

  public var hashValue: Int {
    return self.movie.hashValue
  }

}
