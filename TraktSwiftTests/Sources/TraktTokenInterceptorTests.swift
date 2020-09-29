//@testable import TraktSwift
//import TraktSwiftTestable
//import XCTest
//
//final class TraktTokenInterceptorTests: XCTestCase {
//  private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!
//  private var interceptor: TraktTokenInterceptor!
//  private var trakt: Trakt!
//  private let beginOfTime = Date(timeIntervalSince1970: 0)
//
//  override func setUp() {
//    super.setUp()
//    clearUserDefaults(userDefaultsMock)
//  }
//
//  private func clearUserDefaults(_ userDefaults: UserDefaults) {
//    for (key, _) in userDefaults.dictionaryRepresentation() {
//      userDefaults.removeObject(forKey: key)
//    }
//  }
//
//  func testWithInvalidToken_refreshToken() {
//    // Given
//    let builder = TraktBuilder {
//      $0.clientId = "clientId"
//      $0.clientSecret = "clientSecret"
//      $0.redirectURL = "redirectURL"
//      $0.userDefaults = userDefaultsMock
//      $0.dateProvider = TestableDateProvider(now: beginOfTime.addingTimeInterval(60 * 60 * 24))
//    }
//
//    let token = Token(accessToken: "accesstokenMock", expiresIn: beginOfTime.timeIntervalSince1970,
//                      refreshToken: "refreshtokenMock", tokenType: "type1", scope: "all")
//
//    let trakt = TestableTrakt(builder: builder)
//    trakt.accessToken = token
//
//    let interceptor = TraktTokenInterceptor(trakt: trakt)
//
//    let target = Shows.watchedProgress(showId: "id", hidden: false, specials: false, countSpecials: false)
//    let endpoint = trakt.shows.endpoint(target)
//    let resultExpectation = expectation(description: "expect to have a token on trakt")
//
//    let expectedToken = Token(accessToken: "dbaf9757982a9e738f05d249b7b5b4a266b3a139049317c4909f2f263572c781",
//                              expiresIn: 7200,
//                              refreshToken: "76ba4c5c75c96f6087f58a4de10be6c00b29ea1ddc3b2022ee2016d1363e3a7c",
//                              tokenType: "bearer",
//                              scope: "public")
//
//    // When
//    interceptor.intercept(target: Shows.self, endpoint: endpoint) { _ in
//      // Then
//      resultExpectation.fulfill()
//      XCTAssertNotNil(trakt.accessToken)
//      XCTAssertEqual(trakt.accessToken, expectedToken)
//    }
//
//    wait(for: [resultExpectation], timeout: 1)
//  }
//
//  func testWithAuthenticatedUsedAndOAuthCode_requestToken() {
//    let builder = TraktBuilder {
//      $0.clientId = "clientId"
//      $0.clientSecret = "clientSecret"
//      $0.redirectURL = "redirectURL"
//      $0.userDefaults = userDefaultsMock
//      $0.dateProvider = TestableDateProvider(now: beginOfTime.addingTimeInterval(60 * 60 * 24))
//    }
//
//    let trakt = TestableTrakt(builder: builder)
//    trakt.oauthCode = "my_awesome_code"
//
//    XCTAssertNil(trakt.accessToken)
//
//    let interceptor = TraktTokenInterceptor(trakt: trakt)
//
//    let target = Shows.watchedProgress(showId: "id", hidden: false, specials: false, countSpecials: false)
//    let endpoint = trakt.shows.endpoint(target)
//    let resultExpectation = expectation(description: "expect to have a token on trakt")
//
//    let expectedToken = Token(accessToken: "dbaf9757982a9e738f05d249b7b5b4a266b3a139049317c4909f2f263572c781",
//                              expiresIn: 7200,
//                              refreshToken: "76ba4c5c75c96f6087f58a4de10be6c00b29ea1ddc3b2022ee2016d1363e3a7c",
//                              tokenType: "bearer",
//                              scope: "public")
//
//    // When
//    interceptor.intercept(target: Shows.self, endpoint: endpoint) { _ in
//      // Then
//      resultExpectation.fulfill()
//      XCTAssertNotNil(trakt.accessToken)
//      XCTAssertEqual(trakt.accessToken, expectedToken)
//    }
//
//    wait(for: [resultExpectation], timeout: 1)
//  }
//
//  func testWithAuthenticatedUsedButWithoutOAuthCode_shouldRequest() {
//    let builder = TraktBuilder {
//      $0.clientId = "clientId"
//      $0.clientSecret = "clientSecret"
//      $0.redirectURL = "redirectURL"
//      $0.userDefaults = userDefaultsMock
//      $0.dateProvider = TestableDateProvider(now: beginOfTime.addingTimeInterval(60 * 60 * 24))
//    }
//
//    let trakt = TestableTrakt(builder: builder)
//
//    XCTAssertNil(trakt.accessToken)
//
//    let interceptor = TraktTokenInterceptor(trakt: trakt)
//
//    let target = Shows.watchedProgress(showId: "id", hidden: false, specials: false, countSpecials: false)
//    let endpoint = trakt.shows.endpoint(target)
//    let resultExpectation = expectation(description: "expect to have a token on trakt")
//
//    // When
//    interceptor.intercept(target: Shows.self, endpoint: endpoint) { _ in
//      // Then
//      resultExpectation.fulfill()
//      XCTAssertNil(trakt.accessToken)
//    }
//
//    wait(for: [resultExpectation], timeout: 1)
//  }
//}
