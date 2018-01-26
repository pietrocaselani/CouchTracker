import Foundation
import RxSwift

final class SimpleMemoryCache: Cache {
  typealias Key = Int
  typealias Value = NSData

  private var entries = [Int: NSData]()

  func get(_ key: Key) -> Maybe<Value> {
    return Maybe.create { [unowned self] observer -> Disposable in
      if let value = self.entries[key] {
        observer(.success(value))
      }

      observer(.completed)

      return Disposables.create()
    }
  }

  func set(_ value: Value, for key: Key) -> Completable {
    return Completable.create { [unowned self] observer -> Disposable in
      self.entries[key] = value
      observer(.completed)
      return Disposables.create()
    }
  }

  func clear() {
    entries.removeAll()
  }
}
