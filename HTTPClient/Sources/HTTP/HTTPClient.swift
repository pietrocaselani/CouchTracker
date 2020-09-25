import Combine

public typealias HTTPCallPublisher = AnyPublisher<HTTPResponse, HTTPError>

public struct HTTPClient {
  private let rootResponder: RootResponder

  private init(rootResponder: RootResponder) {
    self.rootResponder = rootResponder
  }

  public static func using(
    responder: HTTPResponding,
    middlewares: [HTTPMiddleware] = []
  ) -> HTTPClient {
    .init(rootResponder: .init(responder: responder, middlewares: middlewares))
  }

  public func call(request: HTTPRequest) -> HTTPCallPublisher {
    print(">>> HTTP calling \(request.path)")
    return rootResponder.respond(to: request)
  }

  public func appending(
    middlewares: HTTPMiddleware...
  ) -> HTTPClient {
    .using(responder: rootResponder, middlewares: middlewares)
  }
}

private struct RootResponder: HTTPResponding {
  private let responder: HTTPResponding
  private let middlewares: [HTTPMiddleware]

  init(responder: HTTPResponding, middlewares: [HTTPMiddleware]) {
    self.responder = responder
    self.middlewares = middlewares
  }

  func respond(to request: HTTPRequest) -> HTTPCallPublisher {
    middlewares
      .makeResponder(chainingTo: responder)
      .respond(to: request)
  }
}
