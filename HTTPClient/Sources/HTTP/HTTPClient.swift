import Combine

public typealias HTTPCallPublisher = AnyPublisher<HTTPResponse, HTTPError>

public struct HTTPClient {
  private let rootResponder: HTTPResponder

  private init(rootResponder: HTTPResponder) {
    self.rootResponder = rootResponder
  }

  public static func using(
    responder: HTTPResponder,
    middlewares: [HTTPMiddleware] = []
  ) -> HTTPClient {
    .init(rootResponder: .from(rootResponder: responder, middlewares: middlewares))
  }

  public func call(request: HTTPRequest) -> HTTPCallPublisher {
    rootResponder.respondTo(request)
  }

  public func appending(
    middlewares: HTTPMiddleware...
  ) -> HTTPClient {
    .using(responder: rootResponder, middlewares: middlewares)
  }
}

private extension HTTPResponder {
  static func from(
    rootResponder: HTTPResponder,
    middlewares: [HTTPMiddleware]
  ) -> HTTPResponder {
    .init(respondTo: { request in
      middlewares
        .makeResponder(chainingTo: rootResponder)
        .respondTo(request)
    })
  }
}
