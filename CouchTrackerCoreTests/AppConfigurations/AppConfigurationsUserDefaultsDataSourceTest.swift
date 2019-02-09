@testable import CouchTrackerCore
import RxSwift
import RxTest
import TraktSwift
import XCTest

final class AppStateUserDefaultsDataSourceTest: XCTestCase {
  private var userDefaultsMock: UserDefaults!
  private var dataSource: AppStateUserDefaultsDataSource!
  private var scheduler: TestScheduler!
  private var observer: TestableObserver<LoginState>!
  private var hideSpecialsObserver: TestableObserver<Bool>!

  override func setUp() {
    super.setUp()

    scheduler = TestScheduler(initialClock: 0)
    observer = scheduler.createObserver(LoginState.self)
    hideSpecialsObserver = scheduler.createObserver(Bool.self)
    userDefaultsMock = UserDefaults(suiteName: "AppStateUserDefaultsDataSourceTest")!
    userDefaultsMock.clear()
  }

  override func tearDown() {
    userDefaultsMock = nil
    dataSource = nil

    super.tearDown()
  }

  func testAppConfigurationUserDefaultsDataSource_fetchLoginStateWithEmptyUserDefaults_emitsNotLogged() {
    // Given an empty user defaults
    userDefaultsMock.clear()
    dataSource = AppStateUserDefaultsDataSource(userDefaults: userDefaultsMock)

    // When
    _ = dataSource.fetchLoginState().subscribe(observer)
    scheduler.start()

    // Then
    let expectedEvents: [Recorded<Event<LoginState>>] = [Recorded.next(0, LoginState.notLogged)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testAppConfigurationUserDefaultsDataSource_fetchSettingsWithInvalidUserDefaults_emitsNotLogged() {
    // Given an invalid user defaults
    let data = "{ \"key1\": \"value1\", \"key2\": false }".data(using: .utf8)!
    userDefaultsMock.set(data, forKey: "traktUser")
    dataSource = AppStateUserDefaultsDataSource(userDefaults: userDefaultsMock)

    // When
    _ = dataSource.fetchLoginState().subscribe(observer)
    scheduler.start()

    // Then
    let expectedEvents: [Recorded<Event<LoginState>>] = [Recorded.next(0, LoginState.notLogged)]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testAppConfigurationUserDefaultsDataSource_fetchLoginStateWithValidUserDefaults_emitsLogged() {
    // Given a valid user defaults
    let settingsData = Users.settings.sampleData
    userDefaultsMock.set(settingsData, forKey: "traktUser")
    dataSource = AppStateUserDefaultsDataSource(userDefaults: userDefaultsMock)

    // When
    _ = dataSource.fetchLoginState().subscribe(observer)
    scheduler.start()

    // Then
    let expectedSettings = TraktEntitiesMock.createUserSettingsMock()
    let expectedEvents = [Recorded.next(0, LoginState.logged(settings: expectedSettings))]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testAppConfigurationUserDefaultsDataSource_saveSettings() {
    // Given
    XCTAssertNil(userDefaultsMock.data(forKey: "traktUser"))
    dataSource = AppStateUserDefaultsDataSource(userDefaults: userDefaultsMock)
    let settings = TraktEntitiesMock.createUserSettingsMock()

    // When
    do {
      try dataSource.save(settings: settings)
    } catch {
      XCTFail(error.localizedDescription)
    }

    // Then
    XCTAssertNotNil(userDefaultsMock.data(forKey: "traktUser"))
  }

  func testAppStateUserDefaultsDataSource_toggleHideSpecials() {
    // Given
    XCTAssertFalse(userDefaultsMock.bool(forKey: "hideSpecials"))
    dataSource = AppStateUserDefaultsDataSource(userDefaults: userDefaultsMock)

    // When
    do {
      try dataSource.toggleHideSpecials()
    } catch {
      XCTFail(error.localizedDescription)
    }

    // Then
    XCTAssertTrue(userDefaultsMock.bool(forKey: "hideSpecials"))

    // When
    do {
      try dataSource.toggleHideSpecials()
    } catch {
      XCTFail(error.localizedDescription)
    }

    // Then
    XCTAssertFalse(userDefaultsMock.bool(forKey: "hideSpecials"))
  }

  func testAppStateUserDefaultsDataSource_fetchHideSpecials() {
    // Given
    XCTAssertFalse(userDefaultsMock.bool(forKey: "hideSpecials"))
    dataSource = AppStateUserDefaultsDataSource(userDefaults: userDefaultsMock)

    // When
    _ = dataSource.fetchHideSpecials().subscribe(hideSpecialsObserver)

    // Then
    var expectedEvents = [Recorded.next(0, false)]
    XCTAssertEqual(hideSpecialsObserver.events, expectedEvents)

    // When
    do {
      try dataSource.toggleHideSpecials()
    } catch {
      XCTFail(error.localizedDescription)
    }

    // Then
    expectedEvents = [Recorded.next(0, false), Recorded.next(0, true)]
    XCTAssertEqual(hideSpecialsObserver.events, expectedEvents)
  }
}
