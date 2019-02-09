import RxSwift

public extension PrimitiveSequence where Trait == CompletableTrait {
  public static func from(_ function: @escaping () throws -> Void) -> Completable {
    return Completable.create { completable -> Disposable in
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
