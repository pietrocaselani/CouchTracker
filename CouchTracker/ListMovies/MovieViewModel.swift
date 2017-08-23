//
//  MovieViewModel.swift
//  CouchTracker
//
//  Created by Pietro Caselani on 8/18/17.
//  Copyright © 2017 ArcTouch LLC. All rights reserved.
//

struct MovieViewModel {
  let title: String
}

extension MovieViewModel: Equatable, Hashable {

  static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
    return lhs.title == rhs.title
  }

  var hashValue: Int {
    return title.hashValue
  }

}
