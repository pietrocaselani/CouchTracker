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

struct MovieDetailsViewModel {

  let title: String
  let tagline: String
  let overview: String
  let genres: String
  let releaseDate: String

}

extension MovieDetailsViewModel: Equatable, Hashable {

  static func == (lhs: MovieDetailsViewModel, rhs: MovieDetailsViewModel) -> Bool {
    return lhs.title == rhs.title && lhs.releaseDate == rhs.releaseDate
  }

  var hashValue: Int {
    return title.hashValue * releaseDate.hashValue
  }

}
