import RxSwift

extension ObservableType where E: Sequence {
  public func mapElements<R>(_ mapper: @escaping (E.Element) -> R) -> Observable<[R]> {
    return map { $0.map(mapper) }
  }
}
