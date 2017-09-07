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
}
