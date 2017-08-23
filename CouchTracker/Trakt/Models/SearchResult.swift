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

public final class SearchResult: ImmutableMappable {

  public let type: SearchType
  public let score: Double?
  public let movie: Movie?

  public init(map: Map) throws {
    self.type = try map.value("type")
    self.score = try? map.value("score")
    self.movie = try? map.value("movie")
  }
}

extension SearchResult: Hashable {

  public var hashValue: Int {
    var hash = type.rawValue.hashValue

    hash ^= (score?.hashValue ?? 1)

    hash ^= (movie?.hashValue ?? 1)

    return hash
  }

  public static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
