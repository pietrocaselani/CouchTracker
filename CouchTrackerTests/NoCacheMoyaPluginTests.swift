import XCTest
import Moya
import Foundation
import TraktSwift

final class NoCacheMoyaPluginTests: XCTestCase {
  static let CacheControlHeader = "Cache-Control"
  private let plugin = NoCacheMoyaPlugin()

  func testAddCacheHeaderToRequest() {
    let url = URL(string: "https://fakeurl.com")!
    let request = URLRequest(url: url)

    let target = Users.settings

    let newRequest = plugin.prepare(request, target: target)

    let value = newRequest.value(forHTTPHeaderField: NoCacheMoyaPluginTests.CacheControlHeader)

    XCTAssertEqual(value, "no-cache")
  }

  func testReplaceCacheHeaderToRequest() {
    let url = URL(string: "https://fakeurl.com")!
    var request = URLRequest(url: url)
    request.addValue("mock", forHTTPHeaderField: NoCacheMoyaPluginTests.CacheControlHeader)

    let target = Users.settings

    let newRequest = plugin.prepare(request, target: target)

    let value = newRequest.value(forHTTPHeaderField: NoCacheMoyaPluginTests.CacheControlHeader)

    XCTAssertEqual(value, "no-cache")
  }

}
