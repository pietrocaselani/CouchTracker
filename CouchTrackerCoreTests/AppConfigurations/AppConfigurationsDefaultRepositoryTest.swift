@testable import CouchTrackerCore
import RxSwift
import RxTest
import TraktSwift
import XCTest

final class AppStateUserDefaultsRepositoryTest: XCTestCase {
  private var repository: AppStateDefaultRepository!
  private var dataSource: AppConfigurationDataSourceMock!
  private var network: AppStateNetworkMock!
  private var schedulers: TestSchedulers!
  private var observer: TestableObserver<LoginState>!

  override func setUp() {
    super.setUp()

    schedulers = TestSchedulers()
    observer = schedulers.createObserver(LoginState.self)
  }

  private func setupWithSettings(_ settings: Settings? = nil) {
    dataSource = AppConfigurationDataSourceMock(settings: settings)
    network = AppStateNetworkMock()
    repository = AppStateDefaultRepository(dataSource: dataSource, network: network, schedulers: schedulers)
  }

  override func tearDown() {
    repository = nil
    schedulers = nil
    dataSource = nil
    network = nil
    super.tearDown()
  }

  func testAppStateUserDefaultsRepository_fetchLoginStateWithEmptyDataSource_emitsNotLoggedAndTriesOnNetworkAndSavesOnDataSource() {
    // Given an empty repository
    setupWithSettings()

    // When
    _ = repository.fetchLoginState().subscribe(observer)
    schedulers.start()

    // Then
    let testExpectation = expectation(description: "Expect to be logged")

    DispatchQueue.main.async {
      testExpectation.fulfill()

      let notLoggedState = LoginState.notLogged
      let loggedState = LoginState.logged(settings: TraktEntitiesMock.createUserSettingsMock())
      let expectedEvents = [Recorded.next(1, notLoggedState), Recorded.next(3, loggedState)]

      XCTAssertEqual(self.observer.events, expectedEvents)
      XCTAssertTrue(self.network.fetchUserSettingsInvoked)
      XCTAssertEqual(self.network.fetchUserSettingsInvokedCount, 1)
      XCTAssertTrue(self.dataSource.invokedSaveSettings)
    }

    wait(for: [testExpectation], timeout: 1)
  }

  func testAppStateUserDefaultsRepository_fetchLoginStateFromDataSource() {
    // Given
    let settings = TraktEntitiesMock.createUserSettingsMock()
    setupWithSettings(settings)

    let repository = AppStateDefaultRepository(dataSource: dataSource, network: network, schedulers: schedulers)

    // When
    _ = repository.fetchLoginState().subscribe(observer)
    schedulers.start()

    // Then
    let testExpectation = expectation(description: "Shoud be logged")

    DispatchQueue.main.async {
      testExpectation.fulfill()

      let expectedLoginState = LoginState.logged(settings: settings)
      let expectedEvents = [Recorded.next(1, expectedLoginState)]
      XCTAssertEqual(self.observer.events, expectedEvents)
      XCTAssertFalse(self.network.fetchUserSettingsInvoked)
      XCTAssertEqual(self.network.fetchUserSettingsInvokedCount, 0)
      XCTAssertFalse(self.dataSource.invokedSaveSettings)
    }

    wait(for: [testExpectation], timeout: 2)
  }

  // TODO: Search more about tests and Rx. Because if the data source emits an error, the stream should retry from the datasource, after finish the network operation
  //  func testAppStateDefaultRepository_fetchLoginStateFromDataSourceWithError_thenEmitsNotLoggedAndTriesFetchFromAPI() {
//    //Given
//    let error = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 44)
//    let dataSource = AppStateDataSourceErrorMock(error: error)
//    let network = AppStateNetworkMock()
//    let repository = AppStateDefaultRepository(dataSource: dataSource, network: network, schedulers: schedulers)
//
//    //When
//    _ = repository.fetchLoginState().subscribe(observer)
//    schedulers.start()
//
//    //Then
//    let testExpectation = expectation(description: "Expect to be logged")
//
//    DispatchQueue.main.async {
//      testExpectation.fulfill()
//
//      let notLoggedState = LoginState.notLogged
//      let loggedState = LoginState.logged(settings: TraktEntitiesMock.createUserSettingsMock())
//      let expectedEvents = [Recorded.next(1, notLoggedState), Recorded.next(1, loggedState)]
//
//      XCTAssertEqual(self.observer.events, expectedEvents)
//      XCTAssertTrue(network.fetchUserSettingsInvoked)
//      XCTAssertEqual(network.fetchUserSettingsInvokedCount, 1)
//      XCTAssertTrue(dataSource.saveSettingsInvoked)
//    }
//
//    wait(for: [testExpectation], timeout: 1)
  //  }
}
