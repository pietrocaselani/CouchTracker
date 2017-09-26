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

struct AnyCache<K: Hashable, V>: Cache {
  typealias Key = K
  typealias Value = V

  private let getClosure: (Key) -> Observable<Value>
  private let setClosure: (Value, Key) -> Completable

  init<C: Cache>(_ cache: C) where C.Key == K, C.Value == V {
    self.getClosure = { return cache.get($0) }
    self.setClosure = { return cache.set($0, for: $1) }
  }

  func get(_ key: Key) -> Observable<Value> {
    return getClosure(key)
  }

  func set(_ value: Value, for key: Key) -> Completable {
    return setClosure(value, key)
  }
}
