import XCTest
import TraktSwift
import RxTest
import RxSwift

final class AppConfigurationsUserDefaultsRepositoryTest: XCTestCase {
  private var repository: AppConfigurationsDefaultRepository!
	private var dataSource: AppConfigurationDataSourceMock!
	private var scheduler: TestScheduler!
	private var observer: TestableObserver<LoginState>!

  override func setUp() {
	  dataSource = AppConfigurationDataSourceMock()
    repository = AppConfigurationsDefaultRepository(dataSource: dataSource, traktProvider: traktProviderMock)
	  scheduler = TestScheduler(initialClock: 0)
	  observer = scheduler.createObserver(LoginState.self)

	  super.setUp()
  }

  override func tearDown() {
    repository = nil
	  scheduler = nil
	  dataSource = nil
    super.tearDown()
  }

	func testAppConfigurationsUserDefaultsRepository_fetchLoginStateWithEmptyCacheNotForced_emitsNotLogged() {
		//Given an empty repository

		//When
		_ = repository.fetchLoginState(forced: false).subscribe(observer)
		scheduler.start()

		//Then
    let expectedLoginState = LoginState.notLogged
		let expectedEvents: [Recorded<Event<LoginState>>] = [next(0, expectedLoginState), completed(0)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

  func testAppConfigurationsUserDefaultsRepository_fetchLoginStateWithEmptyCacheForced_emitsLoggedAndSaveOnDataSource() {
    //Given an empty repository
    dataSource.settings = nil

    //When
    _ = repository.fetchLoginState(forced: true).subscribe(observer)
    scheduler.start()

    //Then
    let expectedSettings = TraktEntitiesMock.createUserSettingsMock()
    let expectedLoginState = LoginState.logged(settings: expectedSettings)
    let expectedEvents: [Recorded<Event<LoginState>>] = [next(0, expectedLoginState), completed(0)]

    XCTAssertEqual(observer.events, expectedEvents)
    XCTAssertTrue(dataSource.invokedSaveSettings)
    XCTAssertFalse(dataSource.invokedFetchLoginState)
    XCTAssertEqual(dataSource.settings, expectedSettings)
  }

	func testAppConfigurationsUserDefaultsRepository_fetchLoginStateFromCache() {
		//Given
		let settings = TraktEntitiesMock.createUserSettingsMock()
		dataSource.settings = settings

		let repository = AppConfigurationsDefaultRepository(dataSource: dataSource, traktProvider: TraktErrorProviderMock())

		//When
		_ = repository.fetchLoginState(forced: false).subscribe(observer)

		//Then
    let expectedLoginState = LoginState.logged(settings: settings)
		let expectedEvents = [next(0, expectedLoginState), completed(0)]
		XCTAssertEqual(observer.events, expectedEvents)
	}
}
