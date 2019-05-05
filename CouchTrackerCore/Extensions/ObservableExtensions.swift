import RxSwift

extension ObservableType where E: Sequence {
  public func mapElements<R>(_ mapper: @escaping (E.Element) -> R) -> Observable<[R]> {
    return map { $0.map(mapper) }
  }
}

extension ObservableType {
  public func unwrap<T>() -> Observable<T> where E == T? {
    // swiftlint:disable force_unwrapping
    return filter { $0 != nil }.map { $0! }
  }
}

extension PrimitiveSequenceType where TraitType == MaybeTrait, ElementType: Sequence {
  public func mapElements<R>(_ mapper: @escaping (ElementType.Element) -> R) -> Maybe<[R]> {
    return map { $0.map(mapper) }
  }
}

extension PrimitiveSequenceType where TraitType == SingleTrait, ElementType: Sequence {
  public func mapElements<R>(_ mapper: @escaping (ElementType.Element) -> R) -> Single<[R]> {
    return map { $0.map(mapper) }
  }
}
