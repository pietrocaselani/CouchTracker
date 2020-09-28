import XCTest
import Combine
import HTTPClient
import HTTPClientTestable

final class HTTPClientTests: XCTestCase {
  private var fakeResponder: FakeResponder!
  private var httpClient: HTTPClient!
  private var cancellables = Set<AnyCancellable>()

  override func setUp() {
    super.setUp()

    fakeResponder = FakeResponder()
    httpClient = HTTPClient.using(responder: fakeResponder.makeResponder())
  }

  override func tearDown() {
    fakeResponder = nil
    httpClient = nil
    super.tearDown()
  }

  func testCallsRequest() {
    var request = HTTPRequest()
    request.host = "api.github.com"
    request.path = "/zen"

    fakeResponder.then { request -> HTTPCallPublisher in
      XCTAssertEqual(request.url?.absoluteString, "https://api.github.com/zen")
      return .init(
        response: .fakeFrom(
          request: request,
          data: Data()
        )
      )
    }.then { request -> HTTPCallPublisher in
      XCTAssertEqual(request.url?.absoluteString, "https://api.github.com/zen")
      return .init(
        response: .fakeFrom(
          request: request,
          data: Data()
        )
      )
    }

    httpClient.call(request: request)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { _ in }
      ).store(in: &cancellables)

    httpClient.call(request: request)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { _ in }
      ).store(in: &cancellables)
  }

  func testAppendingMiddlewares() {
    var request = HTTPRequest()
    request.host = "api.github.com"
    request.path = "/zen"

    let queryItem = URLQueryItem(name: "apikey", value: "fake-key")

    let newClient = httpClient.appending(
      middlewares: .addQueryItem(item: queryItem)
    )

    fakeResponder.then { request -> HTTPCallPublisher in
      XCTAssertEqual(request.url?.absoluteString, "https://api.github.com/zen?apikey=fake-key")
      return .init(
        response: .fakeFrom(
          request: request,
          data: Data()
        )
      )
    }

    newClient.call(request: request)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { _ in }
      ).store(in: &cancellables)
  }
}
