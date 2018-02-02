import XCTest
import TraktSwift
import RxTest
import RxSwift

final class AppConfigurationsUserDefaultsRepositoryTest: XCTestCase {
  private var repository: AppConfigurationsDefaultRepository!
	private var dataSource: AppConfigurationDataSourceMock!
	private var scheduler: TestScheduler!
	private var observer: TestableObserver<User>!

  override func setUp() {
	  dataSource = AppConfigurationDataSourceMock()
    repository = AppConfigurationsDefaultRepository(dataSource: dataSource, traktProvider: traktProviderMock)
	  scheduler = TestScheduler(initialClock: 0)
	  observer = scheduler.createObserver(User.self)

	  super.setUp()
  }

  override func tearDown() {
    repository = nil
	  scheduler = nil
	  dataSource = nil
    super.tearDown()
  }

	func testAppConfigurationsUserDefaultsRepository_fetchLoggedUserWithEmptyCache() {
		//Given an empty repository

		//When
		_ = repository.fetchLoggedUser(forced: false).subscribe(observer)
		scheduler.start()

		//Then
		let expectedUser = TraktEntitiesMock.createUserSettingsMock().user
		let expectedEvents: [Recorded<Event<User>>] = [next(0, expectedUser), completed(0)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testAppConfigurationsUserDefaultsRepository_fetchLoggedUserFromAPIAndSaveOnCache() {
		//Given an empty repository

		// When
		_ = repository.fetchLoggedUser(forced: false).subscribe(observer)
		scheduler.start()

		//Then
		let expectedSettings = TraktEntitiesMock.createUserSettingsMock()
		let expectedEvents = [next(0, expectedSettings.user), completed(0)]

		XCTAssertEqual(observer.events, expectedEvents)
		XCTAssertTrue(dataSource.invokedSaveSettings)
		XCTAssertEqual(dataSource.settings!, expectedSettings)
	}

	func testAppConfigurationsUserDefaultsRepository_fetchLoggedUserFromCache() {
		//Given
		let settings = TraktEntitiesMock.createUserSettingsMock()
		dataSource.settings = settings

		let repository = AppConfigurationsDefaultRepository(dataSource: dataSource, traktProvider: TraktErrorProviderMock())

		//When
		_ = repository.fetchLoggedUser(forced: false).subscribe(observer)

		//Then
		let expectedEvents = [next(0, settings.user), completed(0)]
		XCTAssertEqual(observer.events, expectedEvents)
	}
}
