import XCTest
import TraktSwift
import RxSwift
import RxTest

final class AppConfigurationsUserDefaultsDataSourceTest: XCTestCase {
	private var userDefaultsMock: UserDefaults!
	private var dataSource: AppConfigurationsUserDefaultsDataSource!
	private var scheduler: TestScheduler!
	private var observer: TestableObserver<LoginState>!

	override func setUp() {
		super.setUp()

		scheduler = TestScheduler(initialClock: 0)
		observer = scheduler.createObserver(LoginState.self)
		userDefaultsMock = UserDefaults(suiteName: "AppConfigurationsUserDefaultsDataSourceTest")!
		clearUserDefaults(userDefaultsMock)
	}

	override func tearDown() {
		userDefaultsMock = nil
		dataSource = nil

		super.tearDown()
	}

	private func clearUserDefaults(_ userDefaults: UserDefaults) {
		for (key, _) in userDefaults.dictionaryRepresentation() {
			userDefaults.removeObject(forKey: key)
		}
	}

	func testAppConfigurationUserDefaultsDataSource_fetchLoginStateWithEmptyUserDefaults_emitsNotLogged() {
		//Given an empty user defaults
    clearUserDefaults(userDefaultsMock)
    dataSource = AppConfigurationsUserDefaultsDataSource(userDefaults: userDefaultsMock)

		//When
		_ = dataSource.fetchLoginState().subscribe(observer)
		scheduler.start()

		//Then
		let expectedEvents: [Recorded<Event<LoginState>>] = [next(0, LoginState.notLogged)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testAppConfigurationUserDefaultsDataSource_fetchSettingsWithInvalidUserDefaults_emitsNotLogged() {
		//Given an invalid user defaults
		let data = "{ \"key1\": \"value1\", \"key2\": false }".data(using: .utf8)!
		userDefaultsMock.set(data, forKey: "traktUser")
    dataSource = AppConfigurationsUserDefaultsDataSource(userDefaults: userDefaultsMock)

		//When
		_ = dataSource.fetchLoginState().subscribe(observer)
		scheduler.start()

		//Then
    let expectedEvents: [Recorded<Event<LoginState>>] = [next(0, LoginState.notLogged)]

    XCTAssertEqual(observer.events, expectedEvents)
	}

	func testAppConfigurationUserDefaultsDataSource_fetchLoginStateWithValidUserDefaults_emitsLogged() {
		//Given a valid user defaults
		let settingsData = Users.settings.sampleData
		userDefaultsMock.set(settingsData, forKey: "traktUser")
    dataSource = AppConfigurationsUserDefaultsDataSource(userDefaults: userDefaultsMock)

		//When
		_ = dataSource.fetchLoginState().subscribe(observer)
		scheduler.start()

		//Then
		let expectedSettings = TraktEntitiesMock.createUserSettingsMock()
		let expectedEvents = [next(0, LoginState.logged(settings: expectedSettings))]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testAppConfigurationUserDefaultsDataSource_saveSettings() {
		//Given
		XCTAssertNil(userDefaultsMock.data(forKey: "traktUser"))
    dataSource = AppConfigurationsUserDefaultsDataSource(userDefaults: userDefaultsMock)
		let settings = TraktEntitiesMock.createUserSettingsMock()

		//When
		do {
			try dataSource.save(settings: settings)
		} catch {
			XCTFail(error.localizedDescription)
		}

		//Then
		XCTAssertNotNil(userDefaultsMock.data(forKey: "traktUser"))
	}
}
