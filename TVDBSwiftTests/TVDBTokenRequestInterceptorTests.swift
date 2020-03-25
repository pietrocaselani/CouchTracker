@testable import TVDBSwift
import XCTest
import Foundation

final class TVDBTokenRequestInterceptorTests: XCTestCase {
  private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!
  private var interceptor: TVDBTokenRequestInterceptor!
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

  func testWithEmptyToken_retriveToken() {
    // Given
    let builder = TVDBBuilder {
      $0.apiKey = "my_apikey"
      $0.userDefaults = userDefaultsMock
    }

    tvdb = TVDBTestable(builder: builder)

    interceptor = TVDBTokenRequestInterceptor(tvdb: tvdb)

    let endpoint = tvdb.episodes.endpoint(.episode(id: 6_040_884))
    let resultExpectation = expectation(description: "expect to have a token on tvdb")

    // When
    interceptor.intercept(target: Episodes.self, endpoint: endpoint) { _ in
      // Then
      resultExpectation.fulfill()
      XCTAssertEqual(self.tvdb.token, "cooltoken!")
    }

    wait(for: [resultExpectation], timeout: 1)
  }

  func testWithInvalidToken_refreshToken() {
    // Given
    let beginOfTime = Date(timeIntervalSince1970: 0)

    let builder = TVDBBuilder {
      $0.apiKey = "my_apikey"
      $0.userDefaults = userDefaultsMock
      $0.dateProvider = TestableDateProvider(now: beginOfTime)
    }

    tvdb = TVDBTestable(builder: builder)
    tvdb.token = "my_token"

    let newBuilder = TVDBBuilder {
      $0.apiKey = "my_apikey"
      $0.userDefaults = userDefaultsMock
      $0.dateProvider = TestableDateProvider(now: beginOfTime.addingTimeInterval(60 * 60 * 24))
    }

    tvdb = TVDBTestable(builder: newBuilder)

    interceptor = TVDBTokenRequestInterceptor(tvdb: tvdb)

    let endpoint = tvdb.episodes.endpoint(.episode(id: 6_040_884))
    let resultExpectation = expectation(description: "expect to have a token on tvdb")

    // When
    interceptor.intercept(target: Episodes.self, endpoint: endpoint) { _ in
      // Then
      resultExpectation.fulfill()
      XCTAssertEqual(self.tvdb.token, "cool_new_token!")
    }

    wait(for: [resultExpectation], timeout: 1)
  }

  func testWithValidToken_tokenShouldBeTheSame() {
    // Given
    let beginOfTime = Date(timeIntervalSince1970: 0)

    let builder = TVDBBuilder {
      $0.apiKey = "my_apikey"
      $0.userDefaults = userDefaultsMock
      $0.dateProvider = TestableDateProvider(now: beginOfTime.addingTimeInterval(60 * 60 * 22))
    }

    let tokenData = NSKeyedArchiver.archivedData(withRootObject: "my_token")
    userDefaultsMock.set(tokenData, forKey: TVDB.accessTokenKey)

    userDefaultsMock.set(beginOfTime.addingTimeInterval(60 * 60 * 20), forKey: TVDB.accessTokenDateKey)

    tvdb = TVDBTestable(builder: builder)

    interceptor = TVDBTokenRequestInterceptor(tvdb: tvdb)

    let endpoint = tvdb.episodes.endpoint(.episode(id: 6_040_884))
    let resultExpectation = expectation(description: "expect to have a token on tvdb")

    // When
    interceptor.intercept(target: Episodes.self, endpoint: endpoint) { _ in
      // Then
      resultExpectation.fulfill()
      XCTAssertNotNil(self.tvdb.token)
      XCTAssertEqual(self.tvdb.token, "my_token")
    }

    wait(for: [resultExpectation], timeout: 1)
  }
}
