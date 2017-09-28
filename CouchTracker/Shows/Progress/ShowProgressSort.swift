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

import Foundation

enum ShowProgressSort: String {
  case title
  case remaining
  case lastWatched

  static func allValues() -> [ShowProgressSort] {
    return [.title, .remaining, .lastWatched]
  }

  static func sort(for index: Int) -> ShowProgressSort {
    if index == 0 { return .title }
    if index == 1 { return .remaining }
    return .lastWatched
  }

  func index() -> Int {
    if self == .title { return 0 }
    if self == .remaining { return 1 }
    return 2
  }

  func comparator() -> (WatchedShowEntity, WatchedShowEntity) -> Bool {
    if self == .title { return titleComparator() }
    if self == .remaining { return remainingComparator() }
    return lastWatchedComparator()
  }

  private func titleComparator() -> (WatchedShowEntity, WatchedShowEntity) -> Bool {
    return { (lhs: WatchedShowEntity, rhs: WatchedShowEntity) in
      let rhsTitle = rhs.show.title ?? ""
      let lhsTitle = lhs.show.title ?? ""
      return lhsTitle < rhsTitle
    }
  }

  private func remainingComparator() -> (WatchedShowEntity, WatchedShowEntity) -> Bool {
    return { (lhs: WatchedShowEntity, rhs: WatchedShowEntity) in
      let lhsRemaining = lhs.aired - lhs.completed
      let rhsRemaining = rhs.aired - rhs.completed
      return lhsRemaining < rhsRemaining
    }
  }

  private func lastWatchedComparator() -> (WatchedShowEntity, WatchedShowEntity) -> Bool {
    return { (lhs: WatchedShowEntity, rhs: WatchedShowEntity) in
      let lhsLastWatched = lhs.lastWatched ?? Date(timeIntervalSince1970: 0)
      let rhsLastWatched = rhs.lastWatched ?? Date(timeIntervalSince1970: 0)
      return lhsLastWatched > rhsLastWatched
    }
  }
}
