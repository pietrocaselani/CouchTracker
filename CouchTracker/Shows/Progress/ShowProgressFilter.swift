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

enum ShowProgressFilter: String {
  case none
  case watched

  static func allValues() -> [ShowProgressFilter] {
    return [.none, .watched]
  }

  static func filter(for index: Int) -> ShowProgressFilter {
    return index == 0 ? .none : .watched
  }

  func index() -> Int {
    return self == .none ? 0 : 1
  }

  func filter() -> (WatchedShowEntity) -> Bool {
    return self == .none ? filterNone() : filterWatched()
  }

  private func filterNone() -> (WatchedShowEntity) -> Bool {
    return { (entity: WatchedShowEntity) in return true }
  }

  private func filterWatched() -> (WatchedShowEntity) -> Bool {
    return { (entity: WatchedShowEntity) in return entity.aired - entity.completed > 0 }
  }
}
