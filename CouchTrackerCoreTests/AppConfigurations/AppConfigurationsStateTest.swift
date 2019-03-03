@testable import CouchTrackerCore
import XCTest

final class AppStateTest: XCTestCase {
  func testAppState_createBuilderFromCurrentState_shouldBeTheSameState() {
    // Given
    let currentState = AppState(userSettings: TraktEntitiesMock.createUserSettingsMock(), hideSpecials: true)

    // When
    let builder = currentState.newBuilder()

    XCTAssertEqual(builder.userSettings, currentState.userSettings)
    XCTAssertEqual(builder.hideSpecials, currentState.hideSpecials)
    XCTAssertEqual(builder.build(), currentState)
  }
}
