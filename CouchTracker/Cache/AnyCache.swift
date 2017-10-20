import RxSwift

struct AnyCache<K: Hashable, V>: Cache {
  typealias Key = K
  typealias Value = V

  private let getClosure: (Key) -> Observable<Value>
  private let setClosure: (Value, Key) -> Completable
  private let clearClosure: () -> Void

  init<C: Cache>(_ cache: C) where C.Key == K, C.Value == V {
    self.getClosure = { return cache.get($0) }
    self.setClosure = { return cache.set($0, for: $1) }
    self.clearClosure = { return cache.clear() }
  }

  func get(_ key: Key) -> Observable<Value> {
    return getClosure(key)
  }

  func set(_ value: Value, for key: Key) -> Completable {
    return setClosure(value, key)
  }

  func clear() {
    clearClosure()
  }
}
