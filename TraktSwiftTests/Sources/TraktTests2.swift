import XCTest
import TraktSwift
import HTTPClientTestable

final class TraktTests2: XCTestCase {
  private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!
  private let fakeClientID = "fake-client-id"
  private let fakeClientSecret = "fake-client-secret"
  private let fakeRedirectURL = URL(string: "couchtracker://fake-url")!

  private var fakeResponder: FakeResponder!

  override func setUp() {
    super.setUp()

    clearUserDefaults(userDefaultsMock)

    fakeResponder = FakeResponder()
  }

  override func tearDown() {
    fakeResponder = nil
    super.tearDown()
  }

  private func clearUserDefaults(_ userDefaults: UserDefaults) {
    for (key, _) in userDefaults.dictionaryRepresentation() {
      userDefaults.removeObject(forKey: key)
    }
  }

  func testTraktInitializesWithoutAuthenticationAPI() throws {
    _ = try Trakt(
      credentials: .init(
        clientId: fakeClientID,
        authData: nil
      ),
      client: .using(responder: fakeResponder.makeResponder()),
      manager: .from(userDefaults: userDefaultsMock, date: Date.init)
    )
  }

  func testTraktInitializeWithAuthData() throws {
    _ = try Trakt(
      credentials: .init(
        clientId: fakeClientID,
        authData: .init(clientSecret: fakeClientSecret, redirectURL: fakeRedirectURL)
      ),
      client: .using(responder: fakeResponder.makeResponder()),
      manager: .from(userDefaults: userDefaultsMock, date: Date.init)
    )
  }
}
