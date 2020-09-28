import Combine

public extension HTTPResponder {
  static func fromURLSession(_ urlSession: URLSession) -> HTTPResponder {
    .init(respondTo: { request in
      let urlRequestResult = request.makeURLRequest()

      switch urlRequestResult {
      case let .failure(httpError):
        return Fail(error: httpError).eraseToAnyPublisher()
      case let .success(urlRequest):
        return urlSession
          .dataTaskPublisher(for: urlRequest)
          .mapError { urlError in
            .urlError(request: request, error: urlError)
          }.flatMap { data, response in
            makeHTTPResponse(data: data, response: response, request: request)
          }.eraseToAnyPublisher()
      }
    })
  }
}

private func makeHTTPResponse(
  data: Data,
  response: URLResponse,
  request: HTTPRequest
) -> AnyPublisher<HTTPResponse, HTTPError> {
  guard let httpURLResponse = response as? HTTPURLResponse else {
    return Fail<HTTPResponse, HTTPError>(
      error: .invalidResponse(request: request)
    ).eraseToAnyPublisher()
  }

  return Just(
    HTTPResponse(
      response: httpURLResponse,
      request: request,
      body: data
    )
  ).setFailureType(to: HTTPError.self)
  .eraseToAnyPublisher()
}
