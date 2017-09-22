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
import Carlos

final class CarlosCache<K: Hashable, V>: Cache {
  typealias Key = K
  typealias Value = V

  private let cache: BasicCache<Key, Value>

  init(basicCache: BasicCache<Key, Value>) {
    self.cache = basicCache
  }

  func get(_ key: Key) -> Observable<Value> {
    return cache.get(key).asObservable().catchError { error -> Observable<V> in
      guard error is FetchError else {
        return Observable.error(error)
      }

      return Observable.empty()
    }
  }

  func set(_ value: V, for key: K) -> Completable {
    return cache.set(value, forKey: key).asCompletable().catchError { error -> Completable in
      guard error is FetchError else {
        return Completable.error(error)
      }

      return Completable.empty()
    }
  }
}
