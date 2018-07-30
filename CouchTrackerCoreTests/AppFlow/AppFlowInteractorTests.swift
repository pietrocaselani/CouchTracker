@testable import CouchTrackerCore
import XCTest

final class AppFlowInteractorTests: XCTestCase {
    func testAppFlowInteractor_updateLastSelectedTab_shouldNotifyRepository() {
        // Given
        let repository = AppFlowMocks.Repository()
        let interactor = AppFlowService(repository: repository)

        // When
        interactor.lastSelectedTab = 3

        // Then
        XCTAssertTrue(repository.lastSelectedTabInvoked)
        XCTAssertEqual(repository.lastSelectedTabParameter, 3)
        XCTAssertEqual(interactor.lastSelectedTab, 3)
    }
}
