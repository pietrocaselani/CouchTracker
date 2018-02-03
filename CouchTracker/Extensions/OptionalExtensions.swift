extension Optional {
  func run(action: (Wrapped) -> Void) {
    if case .some(let value) = self {
      action(value)
    }
  }
}
