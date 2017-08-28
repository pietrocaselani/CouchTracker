//
//  Trakt_MacTests.swift
//  Trakt-MacTests
//
//  Created by Pietro Caselani on 8/28/17.
//  Copyright © 2017 ArcTouch LLC. All rights reserved.
//

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
}
