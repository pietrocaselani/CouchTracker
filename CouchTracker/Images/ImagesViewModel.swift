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

struct ImagesViewModel: Hashable {
  let posterLink: String?
  let backdropLink: String?

  var hashValue: Int {
    var hash = 0

    if let posterLinkHash = posterLink?.hashValue {
      hash = hash ^ posterLinkHash
    }

    if let backdropLinkHash = backdropLink?.hashValue {
      hash = hash ^ backdropLinkHash
    }

    return hash
  }

  static func == (lhs: ImagesViewModel, rhs: ImagesViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
