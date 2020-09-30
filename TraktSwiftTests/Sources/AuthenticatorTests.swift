import XCTest
import Combine
import HTTPClient
@testable import TraktSwift
import TraktSwiftTestable
import HTTPClientTestable

final class AuthenticatorTests: XCTestCase {
  private var cancellables = Set<AnyCancellable>()
  private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!

  private var fakeResponder: FakeResponder!

  override func setUp() {
    super.setUp()

    clearUserDefaults(userDefaultsMock)

    fakeResponder = FakeResponder()
  }

  override func tearDown() {
    fakeResponder = nil
    super.tearDown()
  }

  private func clearUserDefaults(_ userDefaults: UserDefaults) {
    for (key, _) in userDefaults.dictionaryRepresentation() {
      userDefaults.removeObject(forKey: key)
    }
  }

  func testOAuthURL() throws {
    let trakt = try Trakt(
      credentials: .fakeAuth,
      client: .using(responder: fakeResponder.makeResponder()),
      manager: .from(userDefaults: userDefaultsMock, date: Date.init)
    )

    let authenticator = try XCTUnwrap(trakt.authenticator)

    XCTAssertEqual(
      authenticator.oauthURL.absoluteString,
      "https://trakt.tv/oauth/authorize?response_type=code&client_id=fake-client-id&redirect_uri=couchtracker://fake-url"
    )
  }

  func testFinishesAuthenticationAndSavesToken() throws {
    let now = Date()
    let dateProvider = { now }

    let tokenManager = TokenManager.from(
      userDefaults: userDefaultsMock,
      date: dateProvider
    )

    let trakt = try Trakt(
      credentials: .fakeAuth,
      client: .using(responder: fakeResponder.makeResponder()),
      manager: tokenManager
    )

    let authenticator = try XCTUnwrap(trakt.authenticator)

    let data = try TraktTestableBundle.data(forResource: "trakt_token")

    fakeResponder.then { request -> HTTPCallPublisher in
      assertTraktHeaders(in: request)
      XCTAssertEqual(request.url?.absoluteString, "https://api.trakt.tv/oauth/token")

      return .init(response: .fakeFrom(request: request, data: data))
    }

    let wrongURL = URL(string: "https://google.com")!
    let correctURLNoCode = URL(string: "couchtracker://fake-url")!
    let correctURLAuthCode = URL(string: "couchtracker://fake-url?a=2&code=fake-code&b=42")!

    var receivedValues = [AuthenticationResult]()
    var receivedCompletions = [Subscribers.Completion<HTTPError>]()

    let tokenExpectation = expectation(description: "Expect to complete with token")
    tokenExpectation.expectedFulfillmentCount = 3

    let completionHandler: (Subscribers.Completion<HTTPError>) -> Void = { completion in
      tokenExpectation.fulfill()
      receivedCompletions.append(completion)
    }

    let valuesHandler: (AuthenticationResult) -> Void = {
      receivedValues.append($0)
    }

    [wrongURL, correctURLNoCode, correctURLAuthCode].forEach { url in
      authenticator.finishAuthentication(
        request: .init(url: url)
      ) .sink(
        receiveCompletion: completionHandler,
        receiveValue: valuesHandler
      ).store(in: &cancellables)
    }

    wait(for: [tokenExpectation], timeout: 1)

    XCTAssertEqual(receivedValues, [
      .undetermined,
      .undetermined,
      .authenticated
    ])

    XCTAssertEqual(receivedCompletions, [
      .finished,
      .finished,
      .finished
    ])

    let expectedToken = Token.fake()

    let status = tokenManager.tokenStatus()

    XCTAssertEqual(status, TokenManager.TokenStatus.valid(expectedToken))
  }
}

func assertTraktHeaders(
  in request: HTTPRequest
) {
  let headers = request.headers

  XCTAssertEqual(headers["trakt-api-key"], fakeClientID)
  XCTAssertEqual(headers["trakt-api-version"], "2")
  XCTAssertEqual(headers["Content-Type"], "application/json")
}
