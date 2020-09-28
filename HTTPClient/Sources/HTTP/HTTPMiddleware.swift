public struct HTTPMiddleware {
  public let respondToRequestAndCallResponder: (HTTPRequest, HTTPResponder) -> HTTPCallPublisher

  public init(
    respondToRequestAndCallResponder: @escaping (HTTPRequest, HTTPResponder) -> HTTPCallPublisher
  ) {
    self.respondToRequestAndCallResponder = respondToRequestAndCallResponder
  }
}

private extension HTTPMiddleware {
  func makeRespponder(chainingTo responder: HTTPResponder) -> HTTPResponder {
    .init(
      respondTo: { request -> HTTPCallPublisher in
        self.respondToRequestAndCallResponder(request, responder)
      }
    )
  }
}

extension Array where Element == HTTPMiddleware {
  func makeResponder(chainingTo responder: HTTPResponder) -> HTTPResponder {
    var responder = responder

    for middleware in reversed() {
      responder = middleware.makeRespponder(chainingTo: responder)
    }

    return responder
  }
}
