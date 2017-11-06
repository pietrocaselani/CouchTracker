import RxSwift

class CacheMock: Cache {
  typealias Key = Int
  typealias Value = NSData

  var getInvoked = false
  var setInvoked = false

  var entries: [Int: NSData]

  init(entries: [Int: NSData] = [Int:NSData]()) {
    self.entries = entries
  }

  func get(_ key: Int) -> Maybe<NSData> {
    getInvoked = true
    guard let value = entries[key] else { return Maybe.empty() }
    return Maybe.just(value)
  }

  func set(_ value: NSData, for key: Int) -> Completable {
    setInvoked = true
    entries[key] = value
    return Completable.empty()
  }

  func clear() {
    entries.removeAll()
  }
}

final class CacheErrorMock: CacheMock {
  let error: Error

  init(entries: [Int : NSData] = [Int:NSData](), error: Error) {
    self.error = error
    super.init(entries: entries)
  }

  override func get(_ key: Int) -> Maybe<NSData> {
    _ = super.get(key)
    return Maybe.error(error)
  }
}
