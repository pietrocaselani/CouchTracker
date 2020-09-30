import XCTest
import Combine
import HTTPClient
@testable import TraktSwift
import TraktSwiftTestable
import HTTPClientTestable

final class TokenManagerTests: XCTestCase {
  private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!

  override func setUp() {
    super.setUp()

    clearUserDefaults(userDefaultsMock)
  }

  private func clearUserDefaults(_ userDefaults: UserDefaults) {
    for (key, _) in userDefaults.dictionaryRepresentation() {
      userDefaults.removeObject(forKey: key)
    }
  }

  func testTokenManagerStartsWithInvalidToken() {
    let beginOfTime = Date(timeIntervalSince1970: 0)
    let testDate = beginOfTime

    let manager = TokenManager.from(
      userDefaults: userDefaultsMock,
      date: { testDate }
    )

    XCTAssertEqual(manager.tokenStatus(), .invalid)
  }

  func testTokenInvalidValidRefreshFlow() throws {
    let beginOfTime = Date(timeIntervalSince1970: 0)
    var testDate = beginOfTime

    let manager = TokenManager.from(
      userDefaults: userDefaultsMock,
      date: { testDate }
    )

    XCTAssertEqual(manager.tokenStatus(), .invalid)

    let token = try manager.saveToken(.fake()).get()

    XCTAssertEqual(manager.tokenStatus(), .valid(token))

    testDate = testDate.addingTimeInterval(7100)

    XCTAssertEqual(manager.tokenStatus(), .valid(token))

    testDate = testDate.addingTimeInterval(100)

    XCTAssertEqual(manager.tokenStatus(), .refresh(token))
  }
}
