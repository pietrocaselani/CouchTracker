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

struct ShowDetailsViewModel: Hashable {
  let title: String
  let overview: String
  let network: String
  let genres: String
  let firstAired: String

  var hashValue: Int {
    var hash = title.hashValue ^ overview.hashValue
    hash = hash ^ network.hashValue ^ genres.hashValue
    return hash ^ firstAired.hashValue
  }

  static func == (lhs: ShowDetailsViewModel, rhs: ShowDetailsViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
