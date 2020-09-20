public struct HTTPError: Error, Equatable {
  public let code: Code
  public let request: HTTPRequest
  public let response: HTTPResponse?
  public let underlyingError: NSError?

  public enum Code: Equatable {
    case cancelled
    case invalidURL
    case invalidBody
    case invalidResponse
    case decodingBody
    case noInternetConnection
    case unknown
  }

  public init(
    code: Code,
    request: HTTPRequest,
    response: HTTPResponse?,
    underlyingError: NSError?
  ) {
    self.code = code
    self.request = request
    self.response = response
    self.underlyingError = underlyingError
  }

  static func creatingURL(request: HTTPRequest) -> HTTPError {
    .init(
      code: .unknown,
      request: request,
      response: nil,
      underlyingError: nil
    )
  }

  static func encodingBody(request: HTTPRequest, error: Error) -> HTTPError {
    .init(
      code: .unknown,
      request: request,
      response: nil,
      underlyingError: error as NSError
    )
  }

  static func invalidResponse(request: HTTPRequest) -> HTTPError {
    .init(
      code: .unknown,
      request: request,
      response: nil,
      underlyingError: nil
    )
  }

  static func urlError(request: HTTPRequest, error: URLError) -> HTTPError {
    let code: HTTPError.Code

    // TOOD: Handle all codes?!
    switch error.code {
    case .badURL,
         .unsupportedURL:
      code = .invalidURL
    case .cancelled: code = .cancelled
    case .notConnectedToInternet: code = .noInternetConnection
    default: code = .unknown
    }

    return .init(
      code: code,
      request: request,
      response: nil,
      underlyingError: error as NSError
    )
  }

  static func decodingBody(request: HTTPRequest, response: HTTPResponse, error: Error) -> HTTPError {
    .init(
      code: .decodingBody,
      request: request,
      response: response,
      underlyingError: error as NSError
    )
  }
}
