/*
 Copyright 2017 ArcTouch LLC.
 All rights reserved.

 This file, its contents, concepts, methods, behavior, and operation
 (collectively the "Software") are protected by trade secret, patent,
 and copyright laws. The use of the Software is governed by a license
 agreement. Disclosure of the Software to third parties, in any form,
 in whole or in part, is expressly prohibited except as authorized by
 the license agreement.
 */

import XCTest
import Moya
import RxTest
import RxSwift

final class TraktTests: XCTestCase {
  private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!
  private var authorizeURL: URL!
  private let clientId = "my_awesome_client_id"
  private let clientSecret = "my_awesome_client_secret"
  private let redirectURL = "couchtracker://my_awesome_url"
  private let redirectURLValid = "couchtracker://my_awesome_url?code=my_awesome_code"
  private let scheduler = TestScheduler(initialClock: 0)
  private var trakt: Trakt!

  override func setUp() {
    let link = "https://trakt.tv/oauth/authorize?response_type=code&client_id=\(clientId)&redirect_uri=\(redirectURL)"
    authorizeURL = URL(string: link)!
    clearUserDefaults(userDefaultsMock)
    super.setUp()
  }

  private func clearUserDefaults(_ userDefaults: UserDefaults) {
    for (key, _) in userDefaults.dictionaryRepresentation() {
      userDefaults.removeObject(forKey: key)
    }
  }

  private func setupTrakt() {
    trakt = Trakt(clientId: clientId, userDefaults: userDefaultsMock)
  }

  private func setupTraktForAuthentication(_ token: Token? = nil) {
    if let validToken = token {
      let data = NSKeyedArchiver.archivedData(withRootObject: validToken)
      userDefaultsMock.set(data, forKey: Trakt.accessTokenKey)
    }
    
    trakt = Trakt(clientId: clientId, clientSecret: clientSecret,
                  redirectURL: redirectURL, userDefaults: userDefaultsMock)
  }

  func testTrakt_endpointsHasRequiredHeaders() {
    setupTrakt()
    let endpoint = trakt.movies.endpoint(.trending(page: 0, limit: 0, extended: .full))

    let expectedHeaders = [Trakt.headerTraktAPIVersion: "2",
                           Trakt.headerTraktAPIKey: "my_awesome_client_id",
                           Trakt.headerContentType: "application/json"]

    XCTAssertEqual(endpoint.httpHeaderFields!, expectedHeaders)
  }

  func testTrakt_receivesRedirectURL_createsOAuthURL() {
    //Given
    setupTraktForAuthentication()

    //When
    let url = trakt.oauthURL

    //Then
    let link = "https://trakt.tv/oauth/authorize?response_type=code&client_id=\(clientId)&redirect_uri=\(redirectURL)"
    let expectedURL = URL(string: link)
    XCTAssertEqual(url, expectedURL)
  }

  func testTrakt_validateTokenExpirationDate() {
    //Given
    let token = Token(accessToken: "accesstokenMock", expiresIn: Date().addingTimeInterval(3000),
                      refreshToken: "refreshtokenMock", tokenType: "type1", scope: "all")
    setupTraktForAuthentication(token)

    //When
    let isTokenValid = trakt.hasValidToken

    XCTAssertTrue(isTokenValid)
  }

  func testTrakt_invalidateTokenExpirationDate() {
    //Given
    let token = Token(accessToken: "accesstokenMock", expiresIn: Date(),
                      refreshToken: "refreshtokenMock", tokenType: "type1", scope: "all")
    setupTraktForAuthentication(token)

    //When
    let isTokenValid = trakt.hasValidToken

    XCTAssertFalse(isTokenValid)
  }

  func testTrakt_withAccessToken_addsAuthorizationHeader() {
    //Given
    let token = Token(accessToken: "accesstokenMock", expiresIn: Date().addingTimeInterval(3000),
                      refreshToken: "refreshtokenMock", tokenType: "type1", scope: "all")
    setupTraktForAuthentication(token)
    
    let responseExpectation = expectation(description: "Expect receives response")

    //When
    trakt.users.request(.settings) { result in
      if case .success(let response) = result {
        responseExpectation.fulfill()
        let authorizationValue = response.request?.allHTTPHeaderFields!["Authorization"]
        XCTAssertEqual(authorizationValue, "Bearer accesstokenMock")
      }
    }

    //Then
    wait(for: [responseExpectation], timeout: 2)
  }

  func testTrakt_withoutTraktSecret_authenticationFails() {
    //Given
    trakt = Trakt(clientId: clientId, clientSecret: nil, redirectURL: redirectURLValid, userDefaults: userDefaultsMock)
    let request = URLRequest(url: authorizeURL)
    let observer = scheduler.createObserver(AuthenticationResult.self)

    //When
    _ = trakt.finishesAuthentication(with: request).subscribe(observer)

    //Then
    let expectedError = TraktError.cantAuthenticate(message: "Trying to authenticate without a secret or redirect URL")
    let expectedEvents: [Recorded<Event<AuthenticationResult>>] = [error(0, expectedError)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testTrakt_withoutRedirectURL_authenticationFails() {
    //Given
    trakt = Trakt(clientId: clientId, clientSecret: clientSecret, redirectURL: nil, userDefaults: userDefaultsMock)
    let request = URLRequest(url: authorizeURL)
    let observer = scheduler.createObserver(AuthenticationResult.self)

    //When
    _ = trakt.finishesAuthentication(with: request).subscribe(observer)

    //Then
    let expectedError = TraktError.cantAuthenticate(message: "Trying to authenticate without a secret or redirect URL")
    let expectedEvents: [Recorded<Event<AuthenticationResult>>] = [error(0, expectedError)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testTrakt_forUnknownHost_emitsAuthenticationUndetermined() {
    //Given
    setupTraktForAuthentication()
    let request = URLRequest(url: authorizeURL)
    let observer = scheduler.createObserver(AuthenticationResult.self)

    //When
    _ = trakt.finishesAuthentication(with: request).subscribe(observer)

    //Then
    let expectedEvents = [next(0, AuthenticationResult.undetermined), completed(0)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testTrakt_forURLWithoutCode__emitsAuthenticationUndetermined() {
    //Given
    setupTraktForAuthentication()
    let request = URLRequest(url: URL(string: redirectURL)!)
    let observer = scheduler.createObserver(AuthenticationResult.self)

    //When
    _ = trakt.finishesAuthentication(with: request).subscribe(observer)

    //Then
    let expectedEvents = [next(0, AuthenticationResult.undetermined), completed(0)]

    XCTAssertEqual(observer.events, expectedEvents)
  }
}
