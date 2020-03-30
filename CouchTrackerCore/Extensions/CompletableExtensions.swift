import RxSwift

public extension PrimitiveSequence where Trait == CompletableTrait {
  static func from(_ function: @escaping () throws -> Void) -> Completable {
    Completable.create { completable -> Disposable in
      do {
        try function()
        completable(.completed)
      } catch {
        completable(.error(error))
      }
      return Disposables.create()
    }
  }
}
