import XCTest
import TraktSwift

final class TraktTests: XCTestCase {

  func testParseSyncWatchedShowsJSON() throws {
    let resourcesPath = Bundle(for: Trakt.self).bundlePath

    let bundle = findBundleUsing(resourcesPath: resourcesPath)

    guard let url = bundle.url(forResource: "trakt_sync_watched_shows", withExtension: "json") else {
      XCTFail("Resource not found")
      return
    }

    let data = try Data(contentsOf: url)

    do {
      let shows = try JSONDecoder().decode([BaseShow].self, from: data)
      XCTAssertEqual(shows.count, 105)
    } catch {
      let decodingError = error as! DecodingError
      
      print(decodingError.recoverySuggestion ?? "nil")
      print(decodingError.failureReason ?? "nil")

      XCTFail("Error: \(error.localizedDescription)")
    }
  }

  private func findBundleUsing(resourcesPath: String) -> Bundle {
    var path = "/../"

    var bundle: Bundle? = nil
    var attempt = 0

    repeat {
      bundle = Bundle(path: resourcesPath.appending("\(path)TraktTestsResources.bundle"))
      path.append("../")
      attempt += 1
    } while bundle == nil && attempt < 5

    return bundle!
  }

}
