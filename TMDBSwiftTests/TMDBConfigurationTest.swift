import XCTest
import Combine

@testable import HTTPClient
import TMDBSwift
import TMDBSwiftTestable
import HTTPClientTestable

final class TMDBConfigurationTest: XCTestCase {
  private let fakeResponder = FakeHandlerResponder()
  private var cancellables = Set<AnyCancellable>()

  func testTMDD_configurationRequest() throws {
    let data = try TMDBTestableBundle.data(forResource: "tmdb_configuration")

    let responder = fakeResponder.then { request -> HTTPCallPublisher in
      XCTAssertEqual(request.url?.absoluteString, "https://api.themoviedb.org/3/configuration?api_key=fake-key")
      return .init(response: .fakeFrom(request: request, data: data))
    }

    let tmdb = try TMDB(apiKey: "fake-key", client: .using(responder: responder))

    let configurationExpectation = expectation(description: "Expect configuration")

    tmdb.configuration.get().sink(
      receiveCompletion: { _ in },
      receiveValue: { configuration in
        configurationExpectation.fulfill()
        XCTAssertEqual(configuration.images.secureBaseURL, "https://image.tmdb.org/t/p/")
        XCTAssertEqual(configuration.images.backdropSizes, ["w300", "w780", "w1280", "original"])
        XCTAssertEqual(configuration.images.posterSizes, ["w92", "w154", "w185", "w342", "w500", "w780", "original"])
      }
    ).store(in: &cancellables)
    
    wait(for: [configurationExpectation], timeout: 1)
  }
}
