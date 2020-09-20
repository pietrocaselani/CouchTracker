import XCTest
import Combine
import HTTPClient
import HTTPClientTestable

final class HTTPClientTests: XCTestCase {
  private var fakeResponder: FakeResponder!
  private var httpClient: HTTPClient!
  private var cancellables = Set<AnyCancellable>()

  func setUpHTTPClient(toRespond callPublisher: HTTPCallPublisher) {
    fakeResponder = FakeResponder(callPublisher: callPublisher)
    httpClient = HTTPClient.using(responder: fakeResponder)
  }

  func testCallsRequest() {
    var request = HTTPRequest()
    request.path = "api.github.com/zen"

    let response = HTTPResponse(response: .init(), request: request, body: Data())

    let call = Just<HTTPResponse>(response)
      .eraseToAnyPublisher()
      .setFailureType(to: HTTPError.self)
      .eraseToAnyPublisher()

    setUpHTTPClient(toRespond: call)

    httpClient.call(request: request)
      .sink(
        receiveCompletion: { _ in
          XCTAssertEqual(self.fakeResponder.requests, [request])
        },
        receiveValue: { _ in }
      ).store(in: &cancellables)

    httpClient.call(request: request)
      .sink(
        receiveCompletion: { _ in
          XCTAssertEqual(self.fakeResponder.requests, [request, request])
        },
        receiveValue: { _ in }
      ).store(in: &cancellables)
  }

  func testAppendingMiddlewares() {
    var request = HTTPRequest()
    request.path = "api.github.com/zen"

    let response = HTTPResponse(response: .init(), request: request, body: Data())

    let call = Just<HTTPResponse>(response)
      .eraseToAnyPublisher()
      .setFailureType(to: HTTPError.self)
      .eraseToAnyPublisher()

    setUpHTTPClient(toRespond: call)

    let queryItem = URLQueryItem(name: "apikey", value: "fake-key")

    let newClient = httpClient.appending(
      middlewares: [
        FakeAddQueryItemMiddleware(queryItem: queryItem)
      ]
    )

    var expectedRequest = HTTPRequest(method: .get, headers: [:], body: .empty)
    expectedRequest.path = "api.github.com/zen"
    expectedRequest.query = [.init(name: "apikey", value: "fake-key")]

    newClient.call(request: request)
      .sink(
        receiveCompletion: { _ in
          XCTAssertEqual(self.fakeResponder.requests, [expectedRequest])
        },
        receiveValue: { _ in }
      ).store(in: &cancellables)
  }
}
