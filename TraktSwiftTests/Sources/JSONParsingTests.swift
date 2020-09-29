//@testable import TraktSwift
//import TraktSwiftTestable
//import XCTest
//
//final class JSONParsingTests: XCTestCase {
//  private let userDefaultsMock = UserDefaults(suiteName: "TraktTestUserDefaults")!
//  private let clientId = "my_awesome_client_id"
//  private let clientSecret = "my_awesome_client_secret"
//  private let redirectURL = "couchtracker://my_awesome_url"
//  private let scheduler = TestScheduler(initialClock: 0)
//  private var trakt: Trakt!
//
//  override func setUp() {
//    clearUserDefaults(userDefaultsMock)
//    super.setUp()
//  }
//
//  private func clearUserDefaults(_ userDefaults: UserDefaults) {
//    for (key, _) in userDefaults.dictionaryRepresentation() {
//      userDefaults.removeObject(forKey: key)
//    }
//  }
//
//  private func setupTraktForAuthentication(_ token: Token? = nil) {
//    let builder = TraktBuilder {
//      $0.clientId = clientId
//      $0.clientSecret = clientSecret
//      $0.redirectURL = redirectURL
//      $0.userDefaults = userDefaultsMock
//    }
//
//    trakt = TestableTrakt(builder: builder)
//    trakt.accessToken = token
//  }
//
//  func testParseSyncWatchedShows() {
//    // Given
//    let observer = scheduler.createObserver([BaseShow].self)
//    let token = Token(accessToken: "accesstokenMock", expiresIn: Date().timeIntervalSince1970 + 3000,
//                      refreshToken: "refreshtokenMock", tokenType: "type1", scope: "all")
//    setupTraktForAuthentication(token)
//
//    // Then
//    _ = trakt.sync.rx.request(.watched(type: .shows, extended: [.full])).map([BaseShow].self).asObservable().subscribe(observer)
//
//    XCTAssertEqual(observer.events.count, 2)
//    let event = observer.events.first!
//    XCTAssertFalse(event.value.isStopEvent)
//
//    guard let element = event.value.element else {
//      XCTFail("Event should have an element associated")
//      return
//    }
//
//    XCTAssertEqual(element.count, 125)
//  }
//}
