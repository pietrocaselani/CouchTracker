import RxSwift

extension ObservableType where Element: Sequence {
  public func mapElements<R>(_ mapper: @escaping (Element.Element) -> R) -> Observable<[R]> {
    return map { $0.map(mapper) }
  }
}

extension ObservableType {
  public func unwrap<T>() -> Observable<T> where Element == T? {
    // swiftlint:disable force_unwrapping
    return filter { $0 != nil }.map { $0! }
  }
}

extension PrimitiveSequenceType where Trait == MaybeTrait, Element: Sequence {
  public func mapElements<R>(_ mapper: @escaping (Element.Element) -> R) -> Maybe<[R]> {
    return map { $0.map(mapper) }
  }
}

extension PrimitiveSequenceType where Trait == SingleTrait, Element: Sequence {
  public func mapElements<R>(_ mapper: @escaping (Element.Element) -> R) -> Single<[R]> {
    return map { $0.map(mapper) }
  }
}
