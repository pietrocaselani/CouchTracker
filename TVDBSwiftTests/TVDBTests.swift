@testable import TVDBSwift
import XCTest

final class TVDBTests: XCTestCase {
  private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!
  private var tvdb: TVDB!

  override func setUp() {
    clearUserDefaults(userDefaultsMock)

    let builder = TVDBBuilder {
      $0.apiKey = "my_apikey"
      $0.userDefaults = userDefaultsMock
    }

    tvdb = TVDBTestable(builder: builder)
    super.setUp()
  }

  private func clearUserDefaults(_ userDefaults: UserDefaults) {
    for (key, _) in userDefaults.dictionaryRepresentation() {
      userDefaults.removeObject(forKey: key)
    }
  }

  func testTVDB_cantCreateWithoutAPIKey() {
    let builder = TVDBBuilder {
      $0.apiKey = nil
    }

    expectFatalError(expectedMessage: "TVDB needs an apiKey") {
      _ = TVDB(builder: builder)
    }
  }

  func testTVDB_cantCreateWithoutUserDefaults() {
    let builder = TVDBBuilder {
      $0.apiKey = "my_apikey"
      $0.userDefaults = nil
    }

    expectFatalError(expectedMessage: "TVDB needs an userDefaults") {
      _ = TVDB(builder: builder)
    }
  }

  func testTVDB_handlesLogin() {
    // Given TVDB client without token
    clearUserDefaults(userDefaultsMock)

    // When
    let responseExpectation = expectation(description: "Expect episodes response")

    tvdb.episodes.request(.episode(id: 4)) { result in
      switch result {
      case let .success(response):
        // Then
        responseExpectation.fulfill()
        let requestToken = response.request?.allHTTPHeaderFields!["Authorization"]
        XCTAssertNotNil(requestToken)

        guard let episode = try? response.map(EpisodeResponse.self).episode else {
          XCTFail("Could not decode JSON")
          return
        }

        XCTAssertEqual(episode.filename, "episodes/276564/5634087.jpg")
      case let .failure(error):
        XCTFail(error.localizedDescription)
      }
    }

    wait(for: [responseExpectation], timeout: 2)
  }

  func testTVDB_requiredHeaders() {
    tvdb.token = "my_token"

    tvdb.episodes.request(.episode(id: 4)) { result in
      switch result {
      case let .success(response):
        let headers = response.request!.allHTTPHeaderFields!
        XCTAssertEqual(headers["Accept"], "application/vnd.thetvdb.v2.1.2")
        XCTAssertEqual(headers["Content-Type"], "application/json")
        XCTAssertEqual(headers["Authorization"], "Bearer my_token")
      case let .failure(error):
        XCTFail(error.localizedDescription)
      }
    }
  }

  func testTVDB_loadToken() {
    // Given
    tvdb.token = "cool_token"

    // When
    let builder = TVDBBuilder {
      $0.apiKey = "my_apikey"
      $0.userDefaults = userDefaultsMock
    }

    let client = TVDBTestable(builder: builder)

    // Then
    XCTAssertEqual(client.token, "cool_token")
  }

  func testTVDB_updateToken_setsLastTokenDate() {
    // Given
    let beginOfTime = Date(timeIntervalSince1970: 0)
    let builder = TVDBBuilder {
      $0.apiKey = "my_apikey"
      $0.userDefaults = userDefaultsMock
      $0.dateProvider = TestableDateProvider(now: beginOfTime)
    }
    let tvdb = TVDB(builder: builder)

    // When
    tvdb.token = "testing_token"

    // Then
    XCTAssertNotNil(tvdb.lastTokenDate)
    XCTAssertEqual(tvdb.lastTokenDate, beginOfTime)
  }
}
