import HTTPClient
import Combine

public final class FakeAddQueryItemMiddleware: HTTPMiddleware {
  private let queryItem: URLQueryItem
  
  public init(queryItem: URLQueryItem) {
    self.queryItem = queryItem
  }
  
  public func respond(to request: HTTPRequest, andCallNext responder: HTTPResponding) -> HTTPCallPublisher {
    var request = request
    request.query += [queryItem]
    
    return responder.respond(to: request)
  }
}

public final class FakeResponder: HTTPResponding {
  private let callPublisher: HTTPCallPublisher
  public private(set) var requests = [HTTPRequest]()
  
  public init(callPublisher: HTTPCallPublisher) {
    self.callPublisher = callPublisher
  }
  
  public convenience init(response: HTTPResponse) {
    self.init(callPublisher: .init(response: response))
  }
  
  public convenience init(error: HTTPError) {
    self.init(callPublisher: .init(error: error))
  }
  
  public func respond(to request: HTTPRequest) -> HTTPCallPublisher {
    requests.append(request)
    return callPublisher
  }
}

public final class FakeHandlerResponder: HTTPResponding {
  public typealias MockHandler = (HTTPRequest) -> HTTPCallPublisher
  
  private var nextHandlers = [MockHandler]()
  
  public init() {}
  
  public func respond(to request: HTTPRequest) -> HTTPCallPublisher {
    if nextHandlers.isEmpty == false {
      let next = nextHandlers.removeFirst()
      return next(request)
    } else {
      return .init(error: .fakeError(request))
    }
  }
  
  @discardableResult
  public func then(_ handler: @escaping MockHandler) -> FakeHandlerResponder {
    nextHandlers.append(handler)
    return self
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
