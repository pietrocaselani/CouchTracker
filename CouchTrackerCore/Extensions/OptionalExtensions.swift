extension Optional {
  func run(action: (Wrapped) -> Void) {
    if case let .some(value) = self {
      action(value)
    }
  }

  func flatMap<T>(with function: @autoclosure () -> T?) -> (Wrapped, T)? {
    flatMap { lhs in
      function().map { rhs in
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
