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

  func clear() {
    cache.clear()
  }
}
