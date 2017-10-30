import RxSwift

protocol Cache {
  associatedtype Key: Hashable
  associatedtype Value

  func get(_ key: Key) -> Observable<Value>
  func set(_ value: Value, for key: Key) -> Completable
  func clear()
}