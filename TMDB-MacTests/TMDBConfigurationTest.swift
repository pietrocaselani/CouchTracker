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
