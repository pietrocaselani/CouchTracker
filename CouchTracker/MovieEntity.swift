//
//  MovieEntity.swift
//  CouchTracker
//
//  Created by Pietro Caselani on 8/18/17.
//  Copyright © 2017 ArcTouch LLC. All rights reserved.
//

struct MovieEntity {
  let identifier: String
  let title: String
}

extension MovieEntity: Equatable, Hashable {

  static func == (lhs: MovieEntity, rhs: MovieEntity) -> Bool {
    return lhs.identifier == rhs.identifier &&
      lhs.title == rhs.title
  }

  var hashValue: Int {
    return identifier.hashValue * title.hashValue
  }
}
