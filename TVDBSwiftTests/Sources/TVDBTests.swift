import XCTest
import Combine

@testable import TVDBSwift
import TVDBSwiftTestable
import HTTPClient
import HTTPClientTestable

final class TVDBTests: XCTestCase {
  private var cancellables = Set<AnyCancellable>()
  private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!
  private let fakeResponder = FakeHandlerResponder()
  private let apiKey = "my_apikey"

  private var tokenManager: TokenManager!
  private var tvdb: TVDB!

  override func setUp() {
    clearUserDefaults(userDefaultsMock)

    super.setUp()
  }

  private func clearUserDefaults(_ userDefaults: UserDefaults) {
    for (key, _) in userDefaults.dictionaryRepresentation() {
      userDefaults.removeObject(forKey: key)
    }
  }

  private func setUpTVDB(_ token: String?, middleware: HTTPMiddleware? = nil, date: @escaping () -> Date) throws {
    clearUserDefaults(userDefaultsMock)

    tokenManager = TokenManager.from(userDefaults: userDefaultsMock, date: date)

    if let token = token {
      tokenManager.saveToken(.init(token: token))
    }

    let middlewares = middleware.map { [$0] } ?? []

    tvdb = try TVDB(
      apiKey: apiKey,
      client: .using(responder: fakeResponder, middlewares: middlewares),
      manager: tokenManager
    )
  }

  func testTVDB_handlesLogin() throws {
    try setUpTVDB(nil, date: Date.init)

    let episodesData = try TVDBTestableBundle.data(forResource: "tvdb_episodes")
    let loginData = try TVDBTestableBundle.data(forResource: "tvdb_login")

    fakeResponder.then { request -> HTTPCallPublisher in
      if request.path == "/login" {
        XCTAssertEqual(request.url?.absoluteString, "https://api.thetvdb.com/login")
        return .init(response: .fakeFrom(request: request, data: loginData))
      } else {
        XCTFail("\(request.path) should not be called")
        return .init(error: .fakeError(request))
      }
    }.then { request -> HTTPCallPublisher in
      if request.path.contains("/episodes/") {
        XCTAssertEqual(request.url?.absoluteString, "https://api.thetvdb.com/episodes/4")
        return .init(response: .fakeFrom(request: request, data: episodesData))
      } else {
        XCTFail("\(request.path) should not be called")
        return .init(error: .fakeError(request))
      }
    }

    let episodeExpectation = expectation(description: "Expect episode")

    tvdb.episodes.episodeDetailsForID(4).sink(
      receiveCompletion: { _ in
        XCTAssertEqual(self.tokenManager.tokenStatus().token?.token, "cooltoken!")
      },
      receiveValue: { episodeResponse in
        episodeExpectation.fulfill()

        XCTAssertEqual(episodeResponse.episode.filename, "episodes/276564/5634087.jpg")
      }
    ).store(in: &cancellables)

    wait(for: [episodeExpectation], timeout: 1)
  }

  func testTVDB_requiredHeaders() throws {
    try setUpTVDB("my_token", date: Date.init)

    let episodeExpectation = expectation(description: "Expect episode")

    let episodesData = try TVDBTestableBundle.data(forResource: "tvdb_episodes")

    fakeResponder.then { request -> HTTPCallPublisher in
      let headers = request.headers

      XCTAssertEqual(headers["Accept"], "application/vnd.thetvdb.v2.1.2")
      XCTAssertEqual(headers["Content-Type"], "application/json")
      XCTAssertEqual(headers["Authorization"], "Bearer my_token")

      return .init(response: .fakeFrom(request: request, data: episodesData))
    }

    tvdb.episodes.episodeDetailsForID(6).sink(
      receiveCompletion: { _ in },
      receiveValue: { _ in
        episodeExpectation.fulfill()
      }
    ).store(in: &cancellables)

    wait(for: [episodeExpectation], timeout: 1)
  }

  func testRefreshToken() throws {
    var date = Date()

    let episodeExpectation = expectation(description: "Expect episode with token refreshed")

    let refreshTokenData = try TVDBTestableBundle.data(forResource: "tvdb_refreshtoken")
    let episodesData = try TVDBTestableBundle.data(forResource: "tvdb_episodes")

    try setUpTVDB("my-token", date: { date })

    fakeResponder.then { request -> HTTPCallPublisher in
      if request.path == "/refresh_token" {
        XCTAssertEqual(request.url?.absoluteString, "https://api.thetvdb.com/refresh_token")
        XCTAssertEqual(request.headers["Authorization"], "Bearer my-token")

        return .init(response: .fakeFrom(request: request, data: refreshTokenData))
      } else {
        XCTFail("\(request.path) should not be called")
        return .init(error: .fakeError(request))
      }
    }.then { request -> HTTPCallPublisher in
      XCTAssertEqual(request.url?.absoluteString, "https://api.thetvdb.com/episodes/6")
      return .init(response: .fakeFrom(request: request, data: episodesData))
    }

    date = try XCTUnwrap(Calendar.current.date(byAdding: .day, value: 1, to: date))

    tvdb.episodes.episodeDetailsForID(6).sink(
      receiveCompletion: { _ in },
      receiveValue: { _ in
        episodeExpectation.fulfill()
      }
    ).store(in: &cancellables)

    wait(for: [episodeExpectation], timeout: 1)
  }
}
