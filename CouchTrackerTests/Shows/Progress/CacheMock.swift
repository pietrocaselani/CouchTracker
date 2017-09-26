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

import RxSwift

final class CacheMock: Cache {
  typealias Key = Int
  typealias Value = NSData

  var getInvoked = false
  var setInvoked = false

  var entries: [Int: NSData]

  init(entries: [Int: NSData] = [Int:NSData]()) {
    self.entries = entries
  }

  func get(_ key: Int) -> Observable<NSData> {
    getInvoked = true
    guard let value = entries[key] else { return Observable.empty() }
    return Observable.just(value)
  }

  func set(_ value: NSData, for key: Int) -> Completable {
    setInvoked = true
    entries[key] = value
    return Completable.empty()
  }
}
