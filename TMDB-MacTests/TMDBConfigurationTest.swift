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

final class TMDBConfigurationTest: XCTestCase {

  private let tmdb = TMDB(apiKey: "my_awesome_api_key")

  func testTMDBConfiguration_configurations_buildsCorrectRequest() {
    let endpoint = tmdb.configuration.endpoint(.configuration)

    let urlExpectation = expectation(description: "Creates correct URL")

    tmdb.configuration.requestClosure(endpoint) { result in
      switch result {
      case .success(let request):
        let expectedURL = "https://api.themoviedb.org/3/configuration?api_key=my_awesome_api_key"
        XCTAssertEqual(request.url?.absoluteString, expectedURL)
      case .failure(let error):
        XCTFail(error.localizedDescription)
      }

      urlExpectation.fulfill()
    }

    wait(for: [urlExpectation], timeout: 2)
  }

  func testTMDBConfiguration_configurations_toJSONToModel() {
    let configuration = createConfigurationsMock()

    XCTAssertEqual(configuration.images.secureBaseURL, "https://image.tmdb.org/t/p/")
    XCTAssertEqual(configuration.images.backdropSizes, ["w300", "w780", "w1280", "original"])
    XCTAssertEqual(configuration.images.posterSizes, ["w92", "w154", "w185", "w342", "w500", "w780", "original"])
  }
}
