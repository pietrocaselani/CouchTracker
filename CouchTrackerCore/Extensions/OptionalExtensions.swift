extension Optional {
  func run(action: (Wrapped) -> Void) {
    if case let .some(value) = self {
      action(value)
    }
  }
}
