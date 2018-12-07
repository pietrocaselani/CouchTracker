public enum Container<E> {
  case empty
  case value(_ element: E)
}

extension Container {
  var value: E? {
    guard case let .value(v) = self else { return nil }
    return v
  }
}

extension Container: Equatable where E: Equatable {}

extension Container: Hashable where E: Hashable {}
