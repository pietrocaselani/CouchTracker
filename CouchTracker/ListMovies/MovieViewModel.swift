//
//  MovieViewModel.swift
//  CouchTracker
//
//  Created by Pietro Caselani on 8/18/17.
//  Copyright © 2017 ArcTouch LLC. All rights reserved.
//

struct MovieViewModel: TrendingViewModel {
  var title: String
  var imageLink: String?
}

extension MovieViewModel: Equatable, Hashable {
  static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  var hashValue: Int {
    var hash = title.hashValue

    if let imageLinkHash = imageLink?.hashValue {
      hash = hash ^ imageLinkHash
    }

    return hash
  }
}
