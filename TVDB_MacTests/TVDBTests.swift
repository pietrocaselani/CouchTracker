import XCTest
import Moya_ObjectMapper

final class TVDBTests: XCTestCase {
  private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!
  private var tvdb: TVDB!

  override func setUp() {
    clearUserDefaults(userDefaultsMock)
    tvdb = TVDBTestable(apiKey: "my_apikey", userDefaults: userDefaultsMock)
    super.setUp()
  }

  private func clearUserDefaults(_ userDefaults: UserDefaults) {
    for (key, _) in userDefaults.dictionaryRepresentation() {
      userDefaults.removeObject(forKey: key)
    }
  }

  func testTVDB_handlesLogin() {
    //Given TVDB client without token

    //When
    let responseExpectation = expectation(description: "Expect episodes response")

    tvdb.episodes.request(.episode(id: 4)) { result in
      switch result {
      case .success(let response):
        //Then
        responseExpectation.fulfill()
        let requestToken = response.request?.allHTTPHeaderFields!["Authorization"]
        XCTAssertNotNil(requestToken)

        let episode = try! response.mapObject(EpisodeResponse.self).episode

        XCTAssertEqual(episode.filename, "episodes/276564/5634087.jpg")
      default:
        XCTFail()
      }
    }

    wait(for: [responseExpectation], timeout: 2)
  }

  func testTVDB_requiredHeaders() {
    tvdb.token = "my_token"

    tvdb.episodes.request(.episode(id: 4)) { result in
      switch result {
      case .success(let response):
        let headers = response.request!.allHTTPHeaderFields!
        XCTAssertEqual(headers["Accept"], "application/vnd.thetvdb.v2.1.2")
        XCTAssertEqual(headers["Content-Type"], "application/json")
        XCTAssertEqual(headers["Authorization"], "Bearer my_token")
      default:
        XCTFail()
      }
    }
  }

  func testTVDB_loadToken() {
    //Given
    tvdb.token = "cool_token"

    //When
    let client = TVDB(apiKey: "apiKey", userDefaults: userDefaultsMock)

    //Then
    XCTAssertEqual(client.token, "cool_token")
  }
}
