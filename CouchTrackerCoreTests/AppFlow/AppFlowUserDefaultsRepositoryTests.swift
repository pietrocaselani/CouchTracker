@testable import CouchTrackerCore
import XCTest

final class AppFlowUserDefaultsRepositoryTests: XCTestCase {
  private var userDefaults: UserDefaults!
  private var repository: AppFlowUserDefaultsRepository!

  override func setUp() {
    super.setUp()

    userDefaults = UserDefaults(suiteName: "AppFlowUserDefaultsRepositoryTests")
    userDefaults.clear()

    repository = AppFlowUserDefaultsRepository(userDefaults: userDefaults)
  }

  override func tearDown() {
    userDefaults = nil
    repository = nil

    super.tearDown()
  }

  func testAppFlowUserDefaultsRepository_whenEmpty_shouldReturnDefaultValue() {
    // Given
    XCTAssertNil(userDefaults.object(forKey: "appFlowLastTab"))

    // When
    let lastTabIndex = repository.lastSelectedTab

    // Then
    let defaultValue = 0
    XCTAssertEqual(lastTabIndex, defaultValue)
  }

  func testAppFlowUserDefaultsRepository_requestLastTab_shouldReturnLastSavedValue() {
    // Given
    userDefaults.set(5, forKey: "appFlowLastTab")

    // When
    let lastTabIndex = repository.lastSelectedTab

    // Then
    let expectedValue = 5
    XCTAssertEqual(lastTabIndex, expectedValue)
  }

  func testAppFlowUserDefaultsRepository_updateLastTab_shouldSaveOnUserDefaults() {
    // Given

    // When
    repository.lastSelectedTab = 13

    // Then
    let expectedValue = 13

    let userDefaultsValue = userDefaults.object(forKey: "appFlowLastTab")
    let userDefaultsLastTab = userDefaultsValue as? Int
    XCTAssertNotNil(userDefaultsValue)
    XCTAssertEqual(expectedValue, userDefaultsLastTab)
  }
}
