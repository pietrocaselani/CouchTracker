public struct HTTPResponder {
  public let respondTo: (HTTPRequest) -> HTTPCallPublisher

  public init(
    respondTo: @escaping (HTTPRequest) -> HTTPCallPublisher
  ) {
    self.respondTo = respondTo
  }
}
