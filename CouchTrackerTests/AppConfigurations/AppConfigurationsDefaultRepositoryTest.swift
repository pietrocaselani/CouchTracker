import XCTest
import TraktSwift
import RxTest
import RxSwift

final class AppConfigurationsUserDefaultsRepositoryTest: XCTestCase {
  private var repository: AppConfigurationsDefaultRepository!
	private var dataSource: AppConfigurationDataSourceMock!
	private var network: AppConfigurationsNetworkMock!
	private var scheduler: TestScheduler!
	private var observer: TestableObserver<LoginState>!

  override func setUp() {
	  dataSource = AppConfigurationDataSourceMock()
	  network = AppConfigurationsNetworkMock()
    repository = AppConfigurationsDefaultRepository(dataSource: dataSource, network: network)
	  scheduler = TestScheduler(initialClock: 0)
	  observer = scheduler.createObserver(LoginState.self)

	  super.setUp()
  }

  override func tearDown() {
    repository = nil
	  scheduler = nil
	  dataSource = nil
	  network = nil
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

		let repository = AppConfigurationsDefaultRepository(dataSource: dataSource, network: network)

		//When
		_ = repository.fetchLoginState(forced: false).subscribe(observer)

		//Then
    let expectedLoginState = LoginState.logged(settings: settings)
		let expectedEvents = [next(0, expectedLoginState), completed(0)]
		XCTAssertEqual(observer.events, expectedEvents)
		XCTAssertEqual(network.fetchUserSettingsInvokedCount, 1)
	}

  func testAppConfigurationsDefaultRepository_fetchLoginStateLocallyWithError_thenFetchFromAPI() {
    //Given
	  let error = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 44)
	  let dataSource = AppConfigurationsDataSourceErrorMock(error: error)
	  let network = AppConfigurationsNetworkMock()
	  let repository = AppConfigurationsDefaultRepository(dataSource: dataSource, network: network)

	  //When
	  _ = repository.fetchLoginState(forced: false).subscribe(observer)

	  //Then
	  let settings = TraktEntitiesMock.createUserSettingsMock()
	  let expectedLoginState = LoginState.logged(settings: settings)
	  let expectedEvents = [next(0, expectedLoginState), completed(0)]

	  XCTAssertTrue(network.fetchUserSettingsInvoked)
	  XCTAssertEqual(network.fetchUserSettingsInvokedCount, 1)
	  XCTAssertEqual(observer.events, expectedEvents)
	  XCTAssertTrue(dataSource.saveSettingsInvoked)
  }
}
