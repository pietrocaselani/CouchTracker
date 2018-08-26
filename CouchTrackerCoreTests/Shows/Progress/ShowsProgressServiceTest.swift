@testable import CouchTrackerCore
import RxSwift
import RxTest
import TraktSwift
import XCTest

final class ShowsProgressServiceTest: XCTestCase {
  private let scheduler = TestSchedulers()
  private var observer: TestableObserver<[WatchedShowEntity]>!
  private var repository: ShowsProgressMocks.ShowsProgressRepositoryMock!
  private var listStateDataSource: ShowsProgressMocks.ListStateDataSource!
	private var appConfigurations: AppConfigurationsMock.AppConfigurationsObservableMock!

  override func setUp() {
    super.setUp()

    observer = scheduler.createObserver([WatchedShowEntity].self)

    repository = ShowsProgressMocks.ShowsProgressRepositoryMock(trakt: createTraktProviderMock())
    listStateDataSource = ShowsProgressMocks.ListStateDataSource()
			appConfigurations = AppConfigurationsMock.AppConfigurationsObservableMock()
  }

  func testShowsProgressService_fetchWatchedProgress() {
    // Given
			let interactor = ShowsProgressService(repository: repository,
																																									listStateDataSource: listStateDataSource,
																																									appConfigurationsObservable: appConfigurations,
																																									schedulers: scheduler,
																																									hideSpecials: true)

    // When
    _ = interactor.fetchWatchedShowsProgress().subscribe(observer)
    scheduler.start()

    // Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [next(0, [entity])]

    RXAssertEvents(observer.events, expectedEvents)
  }

  func testShowsProgressService_receiveSameDataFromRepository_emitsOnlyOnce() {
    // Given
			let interactor = ShowsProgressService(repository: repository,
																																									listStateDataSource: listStateDataSource,
																																									appConfigurationsObservable: appConfigurations,
																																									schedulers: scheduler,
																																									hideSpecials: true)
    _ = interactor.fetchWatchedShowsProgress().subscribe(observer)
    scheduler.start()

    // When
    repository.emitsAgain([ShowsProgressMocks.mockWatchedShowEntity()])

    // Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [next(0, [entity])]

    RXAssertEvents(observer.events, expectedEvents)
  }

  func testShowsProgressService_receiveDifferentDataFromRepository_emitsNewData() {
    // Given
			let interactor = ShowsProgressService(repository: repository,
																																									listStateDataSource: listStateDataSource,
																																									appConfigurationsObservable: appConfigurations,
																																									schedulers: scheduler,
																																									hideSpecials: true)
    _ = interactor.fetchWatchedShowsProgress().subscribe(observer)
    scheduler.start()

    // When
    repository.emitsAgain([WatchedShowEntity]())

    // Then
    let entity = ShowsProgressMocks.mockWatchedShowEntity()
    let expectedEvents = [next(0, [entity]), next(0, [WatchedShowEntity]())]

    RXAssertEvents(observer.events, expectedEvents)
  }

  func testShowsProgressService_receivesNewListState_shouldNotifyDataSource() {
    // Given
			let interactor = ShowsProgressService(repository: repository,
																																									listStateDataSource: listStateDataSource,
																																									appConfigurationsObservable: appConfigurations,
																																									schedulers: scheduler,
																																									hideSpecials: true)

    // When
    let listState = ShowProgressListState(sort: .lastWatched, filter: .watched, direction: .asc)
    interactor.listState = listState

    // Then
    XCTAssertEqual(listStateDataSource.currentStateInvokedCount, 1)
    XCTAssertEqual(listStateDataSource.currentState, listState)
  }
}
