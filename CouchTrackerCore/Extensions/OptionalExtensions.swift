extension Optional {
  func run(action: (Wrapped) -> Void) {
    if case let .some(value) = self {
      action(value)
    }
  }

  func flatMap<T>(with f: @autoclosure () -> T?) -> (Wrapped, T)? {
    return flatMap { lhs in
      f().map { rhs in
        (lhs, rhs)
      }
    }
  }

  func orThrow(error: Swift.Error) throws -> Wrapped {
    guard let value = self else {
      throw error
    }
    return value
  }
}
