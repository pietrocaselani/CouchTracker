import XCTest
@testable import CouchTrackerCore

final class AppConfigurationsStateTest: XCTestCase {

	func testAppConfigurationsState_createBuilderFromCurrentState_shouldBeTheSameState() {
		//Given
		let loginState = LoginState.logged(settings: TraktEntitiesMock.createUserSettingsMock())
		let currentState = AppConfigurationsState(loginState: loginState, hideSpecials: true)

		//When
		let builder = currentState.newBuilder()

		XCTAssertEqual(builder.loginState, currentState.loginState)
		XCTAssertEqual(builder.hideSpecials, currentState.hideSpecials)
		XCTAssertEqual(builder.build(), currentState)
	}

}
