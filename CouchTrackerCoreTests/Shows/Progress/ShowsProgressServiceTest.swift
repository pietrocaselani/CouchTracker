import XCTest
import RxSwift
import RxTest
import TraktSwift
@testable import CouchTrackerCore

final class ShowsProgressServiceTest: XCTestCase {
	private let scheduler = TestSchedulers()
	private var observer: TestableObserver<[WatchedShowEntity]>!
	private var repository: ShowsProgressMocks.ShowsProgressRepositoryMock!

	override func setUp() {
		super.setUp()

		observer = scheduler.createObserver([WatchedShowEntity].self)

		repository = ShowsProgressMocks.ShowsProgressRepositoryMock(trakt: createTraktProviderMock())
	}

	func testShowsProgressService_fetchWatchedProgress() {
		//Given
		let interactor = ShowsProgressService(repository: repository, schedulers: scheduler)

		//When
		_ = interactor.fetchWatchedShowsProgress().subscribe(observer)
		scheduler.start()

		//Then
		let entity = ShowsProgressMocks.mockWatchedShowEntity()
		let expectedEvents = [next(0, [entity])]

		RXAssertEvents(observer.events, expectedEvents)
	}

	func testShowsProgressService_receiveSameDataFromRepository_emitsOnlyOnce() {
		//Given
		let interactor = ShowsProgressService(repository: repository, schedulers: scheduler)
		_ = interactor.fetchWatchedShowsProgress().subscribe(observer)
		scheduler.start()

		//When
		repository.emitsAgain([ShowsProgressMocks.mockWatchedShowEntity()])

		//Then
		let entity = ShowsProgressMocks.mockWatchedShowEntity()
		let expectedEvents = [next(0, [entity])]

		RXAssertEvents(observer.events, expectedEvents)
	}

	func testShowsProgressService_receiveDifferentDataFromRepository_emitsNewData() {
		//Given
		let interactor = ShowsProgressService(repository: repository, schedulers: scheduler)
		_ = interactor.fetchWatchedShowsProgress().subscribe(observer)
		scheduler.start()

		//When
		repository.emitsAgain([WatchedShowEntity]())

		//Then
		let entity = ShowsProgressMocks.mockWatchedShowEntity()
		let expectedEvents = [next(0, [entity]), next(0, [WatchedShowEntity]())]

		RXAssertEvents(observer.events, expectedEvents)
	}
}
