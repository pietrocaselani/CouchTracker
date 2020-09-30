import XCTest
import Combine
@testable import TraktSwift
import HTTPClient
import TraktSwiftTestable
import HTTPClientTestable

final class TraktTests2: XCTestCase {
  private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!

  private var cancellables = Set<AnyCancellable>()

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

  func testTraktInitializesWithoutAuthenticationAPI() throws {
    _ = try Trakt(
      credentials: .fakeNoAuth,
      client: .using(responder: fakeResponder.makeResponder()),
      manager: .from(userDefaults: userDefaultsMock, date: Date.init)
    )
  }

  func testTraktInitializeWithAuthData() throws {
    _ = try Trakt(
      credentials: .fakeAuth,
      client: .using(responder: fakeResponder.makeResponder()),
      manager: .from(userDefaults: userDefaultsMock, date: Date.init)
    )
  }

  func testHeadersMiddleware() throws {
    let trakt = try Trakt(
      credentials: .fakeAuth,
      client: .using(responder: fakeResponder.makeResponder()),
      manager: .from(userDefaults: userDefaultsMock, date: Date.init)
    )

    let trendingMoviesData = try TraktTestableBundle.data(forResource: "trakt_movies_trending")

    fakeResponder.then { request -> HTTPCallPublisher in
      XCTAssertEqual(request.path, "/movies/trending")
      XCTAssertEqual(request.headers["trakt-api-key"], fakeClientID)
      XCTAssertEqual(request.headers["trakt-api-version"], "2")
      XCTAssertEqual(request.headers["Content-Type"], "application/json")
      XCTAssertNil(request.headers["Authorization"])

      return .init(response: .fakeFrom(request: request, data: trendingMoviesData))
    }

    let trendingMoviesExpectation = expectation(description: "expects trending movies")

    trakt.movies.trending(
      .init(page: 1, limit: 10, extended: .default)
    ).sink(
      receiveCompletion: { completion in
        trendingMoviesExpectation.fulfill()
      },
      receiveValue: { trendingMovies in
        XCTAssertEqual(trendingMovies.count, 2)
      }
    ).store(in: &cancellables)

    wait(for: [trendingMoviesExpectation], timeout: 1)
  }

  func testAddTokenMiddleware() throws {
    let date = Date(timeIntervalSince1970: 0)

    let tokenManager = TokenManager.inMemory(date: { date })

    _ = tokenManager.saveToken(.fake())

    let trakt = try Trakt(
      credentials: .fakeAuth,
      client: .using(responder: fakeResponder.makeResponder()),
      manager: tokenManager
    )

    let trendingMoviesData = try TraktTestableBundle.data(forResource: "trakt_movies_trending")

    fakeResponder.then { request -> HTTPCallPublisher in
      XCTAssertEqual(request.path, "/movies/trending")
      XCTAssertEqual(request.headers["trakt-api-key"], fakeClientID)
      XCTAssertEqual(request.headers["trakt-api-version"], "2")
      XCTAssertEqual(request.headers["Content-Type"], "application/json")
      XCTAssertEqual(request.headers["Authorization"], "Bearer fake-access-token")

      return .init(response: .fakeFrom(request: request, data: trendingMoviesData))
    }

    let trendingMoviesExpectation = expectation(description: "expects trending movies")

    trakt.movies.trending(
      .init(page: 1, limit: 10, extended: .default)
    ).sink(
      receiveCompletion: { completion in
        trendingMoviesExpectation.fulfill()
      },
      receiveValue: { trendingMovies in
        XCTAssertEqual(trendingMovies.count, 2)
      }
    ).store(in: &cancellables)

    wait(for: [trendingMoviesExpectation], timeout: 1)
  }

  func testRefreshTokenMiddleware() throws {
    var date = Date(timeIntervalSince1970: 0)

    let tokenManager = TokenManager.from(
      userDefaults: userDefaultsMock,
      date: { date }
    )

    XCTAssertEqual(tokenManager.tokenStatus(), .invalid)

    let token = try tokenManager.saveToken(.fake()).get()

    date.addTimeInterval(token.expiresIn)

    let trakt = try Trakt(
      credentials: .fakeAuth,
      client: .using(responder: fakeResponder.makeResponder()),
      manager: tokenManager
    )

    let refreshTokenData = try TraktTestableBundle.data(forResource: "trakt_refreshtoken")
    let trendingMoviesData = try TraktTestableBundle.data(forResource: "trakt_movies_trending")

    fakeResponder.then { request -> HTTPCallPublisher in
      XCTAssertEqual(request.path, "/oauth/token")
      XCTAssertEqual(request.headers["trakt-api-key"], fakeClientID)
      XCTAssertEqual(request.headers["trakt-api-version"], "2")
      XCTAssertEqual(request.headers["Content-Type"], "application/json")
      XCTAssertEqual(request.headers["Authorization"], "Bearer fake-access-token")

      return .init(response: .fakeFrom(request: request, data: refreshTokenData))
    }.then { request -> HTTPCallPublisher in
      XCTAssertEqual(request.path, "/movies/trending")
      XCTAssertEqual(request.headers["trakt-api-key"], fakeClientID)
      XCTAssertEqual(request.headers["trakt-api-version"], "2")
      XCTAssertEqual(request.headers["Content-Type"], "application/json")
      XCTAssertEqual(request.headers["Authorization"], "Bearer fake-access-token-refreshed")

      return .init(response: .fakeFrom(request: request, data: trendingMoviesData))
    }

    let trendingMoviesExpectation = expectation(description: "expects trending movies")

    trakt.movies.trending(
      .init(page: 1, limit: 10, extended: .default)
    ).sink(
      receiveCompletion: { completion in
        trendingMoviesExpectation.fulfill()
      },
      receiveValue: { trendingMovies in
        XCTAssertEqual(trendingMovies.count, 2)
      }
    ).store(in: &cancellables)

    wait(for: [trendingMoviesExpectation], timeout: 1)
  }
}
