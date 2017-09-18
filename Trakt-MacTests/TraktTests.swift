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

final class TraktTests: XCTestCase {
  private let trakt = Trakt(clientId: "my_awesome_client_id")

  func testTrakt_endpointsHasRequiredHeaders() {
    let endpoint = trakt.movies.endpoint(.trending(page: 0, limit: 0, extended: .full))

    let expectedHeaders = [Trakt.headerTraktAPIVersion: "2",
                           Trakt.headerTraktAPIKey: "my_awesome_client_id",
                           Trakt.headerContentType: "application/json"]

    XCTAssertEqual(endpoint.httpHeaderFields!, expectedHeaders)
  }

  func testTrakt_receivesRedirectURL_createsOAuthURL() {
    //Given
    let clientId = "my_awesome_client_id"
    let clientSecret = "my_awesome_client_secret"
    let redirectURL = "my_awesome_url"
    let trakt = Trakt(clientId: clientId, clientSecret: clientSecret, redirectURL: redirectURL)

    //When
    let url = trakt.oauthURL

    //Then
    let link = "https://trakt.tv/oauth/authorize?response_type=code&client_id=\(clientId)&redirect_uri=\(redirectURL)"
    let expectedURL = URL(string: link)
    XCTAssertEqual(url, expectedURL)
  }
}
