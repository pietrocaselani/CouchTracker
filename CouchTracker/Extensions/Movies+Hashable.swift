//
//  Movies+Hashable.swift
//  CouchTracker
//
//  Created by Pietro Caselani on 8/21/17.
//  Copyright © 2017 ArcTouch LLC. All rights reserved.
//

import Trakt

extension Movies: Hashable {
  public var hashValue: Int {
    switch self {
    case .trending(let page, let limit, let extended):
      return self.path.hashValue * page * limit * extended.hashValue
    case .summary(_, let extended):
      return self.path.hashValue * extended.hashValue
    }
  }

  public static func == (lhs: Movies, rhs: Movies) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
