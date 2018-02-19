import XCTest
import RxSwift
import RxTest
import TraktSwift

final class ShowsProgressAPIRepositoryTest: XCTestCase {
  private let trakt = TraktProviderMock()
  private let schedulers = TestSchedulers()

  override func tearDown() {
    super.tearDown()
  }

  func testShowsProgressRepository_fetchesShowsWithEmptyCache_hitOnAPISavesOnCache() {
    //Given
    let dataSource = ShowsProgressMocks.ShowsProgressDataSourceMock()
    let showProgressRepository = ShowProgressMocks.showProgressRepository
    let appConfigsObservable = AppConfigurationsMock.AppConfigurationsObservableMock()
    let network = ShowsProgressMocks.ShowsProgressNetworkMock()
    let repository = ShowsProgressAPIRepository(network: network,
                                                dataSource: dataSource,
                                                schedulers: schedulers,
                                                showProgressRepository: showProgressRepository,
                                                appConfigurationsObservable: appConfigsObservable,
                                                hideSpecials: false)
    let observer = schedulers.createObserver([WatchedShowEntity].self)

    //When
    _ = repository.fetchWatchedShows(extended: .full).subscribe(observer)
    schedulers.start()

    //Then
    let expectedShow = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [next(0, [WatchedShowEntity]()), next(6, [expectedShow])]

    RXAssertEvents(observer.events, expectedEvents)
	  XCTAssertTrue(dataSource.fetchWatchedShowsInvoked)
	  XCTAssertTrue(dataSource.addWatchedShowInvoked)
    XCTAssertEqual([expectedShow], dataSource.addedEntities)
  }

  func testShowsProgressRepository_fetchShowsFromAPIWhenAppStateChanges() {
    let dataSource = ShowsProgressMocks.ShowsProgressDataSourceMock()
    let showProgressRepository = ShowProgressMocks.showProgressRepository
    let appConfigsObservable = AppConfigurationsMock.AppConfigurationsObservableMock()
    let network = ShowsProgressMocks.ShowsProgressNetworkMock()
    let repository = ShowsProgressAPIRepository(network: network,
                                                dataSource: dataSource,
                                                schedulers: schedulers,
                                                showProgressRepository: showProgressRepository,
                                                appConfigurationsObservable: appConfigsObservable,
                                                hideSpecials: false)

    schedulers.start()

    _ = repository.fetchWatchedShows(extended: .full)

    XCTAssertEqual(network.fetchWatchedShowsInvokedCount, 1)

    let networkExpectation = expectation(description: "Should request from network twice")

    let newState = AppConfigurationsState(loginState: .notLogged, hideSpecials: true)
    appConfigsObservable.chage(state: newState)

    DispatchQueue.main.async {
      networkExpectation.fulfill()
      XCTAssertEqual(network.fetchWatchedShowsInvokedCount, 2)
    }

    wait(for: [networkExpectation], timeout: 1)
  }
}
