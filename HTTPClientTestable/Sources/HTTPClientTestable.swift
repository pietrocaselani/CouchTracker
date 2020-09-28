import HTTPClient
import Combine

public extension HTTPMiddleware {
  static func addQueryItem(item: URLQueryItem) -> Self {
    .init { request, responder -> HTTPCallPublisher in
      var request = request
      request.query += [item]

      return responder.respondTo(request)
    }
  }

  static func addHeader(header: String, value: String) -> Self {
    .init { request, responder -> HTTPCallPublisher in
      var request = request
      request.headers[header] = value
      return responder.respondTo(request)
    }
  }
}

public final class FakeResponder {
  public typealias MockHandler = (HTTPRequest) -> HTTPCallPublisher

  private var nextHandlers = [MockHandler]()

  public init() {}

  @discardableResult
  public func then(_ handler: @escaping MockHandler) -> FakeResponder {
    nextHandlers.append(handler)
    return self
  }

  public func makeResponder() -> HTTPResponder {
    .init { request -> HTTPCallPublisher in
      if self.nextHandlers.isEmpty == false {
        let next = self.nextHandlers.removeFirst()
        return next(request)
      } else {
        return .init(error: .fakeError(request))
      }
    }
  }
}

public extension AnyPublisher where Output == HTTPResponse, Failure == HTTPError {
  init(response: HTTPResponse) {
    self = Just(response).setFailureType(to: HTTPError.self).eraseToAnyPublisher()
  }

  init(error: HTTPError) {
    self = Fail(outputType: HTTPResponse.self, failure: error).eraseToAnyPublisher()
  }
}

public extension HTTPError {
  static func fakeError(_ request: HTTPRequest) -> HTTPError {
    HTTPError(
      code: .unknown,
      request: request,
      response: nil,
      underlyingError: nil
    )
  }
}

public extension HTTPResponse {
  static func fakeFrom(
    request: HTTPRequest,
    data: Data = .init()
  ) -> HTTPResponse {
    .init(
      response: .init(
        url: request.url ?? URL(fileURLWithPath: ""),
        mimeType: nil,
        expectedContentLength: data.count,
        textEncodingName: nil
      ),
      request: request,
      body: data
    )
  }
}
