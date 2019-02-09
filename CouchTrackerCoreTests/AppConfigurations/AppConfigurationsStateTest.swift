@testable import CouchTrackerCore
import XCTest

final class AppStateTest: XCTestCase {
  func testAppState_createBuilderFromCurrentState_shouldBeTheSameState() {
    // Given
    let loginState = LoginState.logged(settings: TraktEntitiesMock.createUserSettingsMock())
    let currentState = AppState(loginState: loginState, hideSpecials: true)

    // When
    let builder = currentState.newBuilder()

    XCTAssertEqual(builder.loginState, currentState.loginState)
    XCTAssertEqual(builder.hideSpecials, currentState.hideSpecials)
    XCTAssertEqual(builder.build(), currentState)
  }
}
