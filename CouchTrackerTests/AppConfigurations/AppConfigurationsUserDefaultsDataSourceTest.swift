import XCTest
import TraktSwift
import RxSwift
import RxTest

final class AppConfigurationsUserDefaultsDataSourceTest: XCTestCase {
	private var userDefaultsMock: UserDefaults!
	private var dataSource: AppConfigurationsUserDefaultsDataSource!
	private var scheduler: TestScheduler!
	private var observer: TestableObserver<Settings>!

	override func setUp() {
		super.setUp()

		scheduler = TestScheduler(initialClock: 0)
		observer = scheduler.createObserver(Settings.self)
		userDefaultsMock = UserDefaults(suiteName: "CouchTrackerTestUserDefaults")!
		dataSource = AppConfigurationsUserDefaultsDataSource(userDefaults: userDefaultsMock)
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

	func testAppConfigurationUserDefaultsDataSource_fetchSettingsWithEmptyUserDefaults_emmitsComplete() {
		//Given an empty user defaults

		//When
		_ = dataSource.fetchSettings().subscribe(observer)
		scheduler.start()

		//Then
		let expectedEvents: [Recorded<Event<Settings>>] = [completed(0)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testAppConfigurationUserDefaultsDataSource_fetchSettingsWithInvalidUserDefaults_emmitsError() {
		//Given an invalid user defaults
		let data = "{ \"key1\": \"value1\", \"key2\": false }".data(using: .utf8)!
		userDefaultsMock.set(data, forKey: "traktUser")

		//When
		_ = dataSource.fetchSettings().subscribe(observer)
		scheduler.start()

		//Then
		XCTAssertEqual(observer.events.count, 1)
		XCTAssertNotNil(observer.events.first?.value.error)
	}

	func testAppConfigurationUserDefaultsDataSource_fetchSettingsWithVvalidUserDefaults_emmitsSettingsAndComplete() {
		//Given a valid user defaults
		let settingsData = Users.settings.sampleData
		userDefaultsMock.set(settingsData, forKey: "traktUser")

		//When
		_ = dataSource.fetchSettings().subscribe(observer)
		scheduler.start()

		//Then
		let expectedSettings = TraktEntitiesMock.createUserSettingsMock()
		let expectedEvents = [next(0, expectedSettings), completed(0)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testAppConfigurationUserDefaultsDataSource_saveSettings() {
		//Given
		XCTAssertNil(userDefaultsMock.data(forKey: "traktUser"))
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
