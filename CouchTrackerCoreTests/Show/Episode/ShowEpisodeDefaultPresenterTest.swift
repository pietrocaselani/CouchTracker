import XCTest
import RxTest
import RxSwift
@testable import CouchTrackerCore

final class ShowEpisodeDefaultPresenterTest: XCTestCase {
	private var interactor: ShowEpisodeMocks.Interactor!
	private var presenter: ShowEpisodeDefaultPresenter!
	private var scheduler: TestScheduler!
	private var viewObserver: TestableObserver<ShowEpisodeViewState>!
	private var imageObserver: TestableObserver<ShowEpisodeImageState>!
	private var disposeBag: DisposeBag!

	override func setUp() {
		super.setUp()

		interactor = ShowEpisodeMocks.Interactor()
		scheduler = TestScheduler(initialClock: 0)
		disposeBag = DisposeBag()
		viewObserver = scheduler.createObserver(ShowEpisodeViewState.self)
		imageObserver = scheduler.createObserver(ShowEpisodeImageState.self)
	}

	override func tearDown() {
		presenter = nil
		interactor = nil
		scheduler = nil
		disposeBag = nil
		viewObserver = nil
		imageObserver = nil
		super.tearDown()
	}

	private func setupPresenter(_ show: WatchedShowEntity) {
		presenter = ShowEpisodeDefaultPresenter(interactor: interactor, show: show)
	}

	func testShowEpisodeDefaultPresenter_receivesShowWithoutNextEpisode_notifyViewIsEmpty() {
		//Given
		let show = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode()
		setupPresenter(show)

		presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)
		presenter.observeImageState().subscribe(imageObserver).disposed(by: disposeBag)

		//When
		presenter.viewDidLoad()

		//Then
		let expectedViewEvents = [Recorded.next(0, ShowEpisodeViewState.loading),
																												Recorded.next(0, ShowEpisodeViewState.empty)]

		let expectedImageEvents = [Recorded.next(0, ShowEpisodeImageState.loading),
																													Recorded.next(0, ShowEpisodeImageState.none)]

		XCTAssertEqual(viewObserver.events, expectedViewEvents)
		XCTAssertEqual(imageObserver.events, expectedImageEvents)

		XCTAssertFalse(interactor.fetchImageURLInvoked)
		XCTAssertFalse(interactor.toogleWatchInvoked)
	}

	func testShowEpisodeDefaultPresenter_receivesShowWrongImageId_updateViewWithoutImage() {
		//Given
		let show = ShowsProgressMocks.mockWatchedShowEntity()
		setupPresenter(show)
		let imageError = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 234, userInfo: nil)
		interactor.error = imageError

		presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)
		presenter.observeImageState().subscribe(imageObserver).disposed(by: disposeBag)

		//When
		presenter.viewDidLoad()

		//Then
		guard let nextEpisode = show.nextEpisode else {
			XCTFail("Next Episode can't be nil")
			return
		}

		let expectedViewEvents = [Recorded.next(0, ShowEpisodeViewState.loading),
																												Recorded.next(0, ShowEpisodeViewState.showing(episode: nextEpisode))]

		let expectedImageEvents = [Recorded.next(0, ShowEpisodeImageState.loading),
																													Recorded.next(0, ShowEpisodeImageState.error(error: imageError))]

		XCTAssertEqual(viewObserver.events, expectedViewEvents)
		XCTAssertEqual(imageObserver.events, expectedImageEvents)
		XCTAssertTrue(interactor.fetchImageURLInvoked)
	}

	func testShowEpisodeDefaultPresenter_receivesShow_updateViewAndImage() {
		//Given
		let show = ShowsProgressMocks.mockWatchedShowEntity()
		setupPresenter(show)

		presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)
		presenter.observeImageState().subscribe(imageObserver).disposed(by: disposeBag)

		//When
		presenter.viewDidLoad()

		//Then
		guard let nextEpisode = show.nextEpisode else {
			XCTFail("Next Episode can't be nil")
			return
		}

		let imageURL = URL(string: "path/to/image.png")!

		let expectedViewEvents = [Recorded.next(0, ShowEpisodeViewState.loading),
																												Recorded.next(0, ShowEpisodeViewState.showing(episode: nextEpisode))]

		let expectedImageEvents = [Recorded.next(0, ShowEpisodeImageState.loading),
																													Recorded.next(0, ShowEpisodeImageState.image(url: imageURL))]

		XCTAssertEqual(viewObserver.events, expectedViewEvents)
		XCTAssertEqual(imageObserver.events, expectedImageEvents)
		XCTAssertTrue(self.interactor.fetchImageURLInvoked)
	}

	func testShowEpisodeDefaultPresenter_handleWatch_invokesInteractorAndUpdateView() {
		//Given
		let show = ShowsProgressMocks.mockWatchedShowEntity()
		setupPresenter(show)
		let newShow = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode()
		interactor.nextEntity = newShow

		presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)
		presenter.observeImageState().subscribe(imageObserver).disposed(by: disposeBag)

		presenter.viewDidLoad()

		//When
		let results = scheduler.start { self.presenter.handleWatch().asObservable() }

		//Then
		guard let nextEpisode = show.nextEpisode else {
			XCTFail("Next Episode can't be nil")
			return
		}

		let expectedHandleWatchedResults = [Recorded.next(200, SyncResult.success(show: newShow)),
																																						Recorded.completed(200)]

		let expectedViewEvents = [Recorded.next(0, ShowEpisodeViewState.loading),
																												Recorded.next(0, ShowEpisodeViewState.showing(episode: nextEpisode)),
																												Recorded.next(200, ShowEpisodeViewState.empty)]

		let expectedImageEvents = [Recorded.next(0, ShowEpisodeImageState.loading),
																													Recorded.next(0, ShowEpisodeImageState.image(url: URL(string: "path/to/image.png")!)),
																													Recorded.next(200, ShowEpisodeImageState.none)]

		XCTAssertEqual(results.events, expectedHandleWatchedResults)
		XCTAssertEqual(viewObserver.events, expectedViewEvents)
		XCTAssertEqual(imageObserver.events, expectedImageEvents)

		XCTAssertTrue(interactor.toogleWatchInvoked)
		XCTAssertTrue(interactor.fetchImageURLInvoked)
	}

	func testShowEpisodeDefaultPresenter_handleWatchFail_notifyRouter() {
		//Given
		let show = ShowsProgressMocks.mockWatchedShowEntity()
		setupPresenter(show)
		let watchedError = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 234, userInfo: nil)
		interactor.toogleFailError = watchedError

		presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)
		presenter.observeImageState().subscribe(imageObserver).disposed(by: disposeBag)

		presenter.viewDidLoad()

		//When
		let results = scheduler.start { self.presenter.handleWatch().asObservable() }

		//Then
		guard let nextEpisode = show.nextEpisode else {
			XCTFail("Next Episode can't be nil")
			return
		}

		let expectedHandleWatchedResults = [Recorded.next(200, SyncResult.fail(error: watchedError)),
																																						Recorded.completed(200)]

		let expectedViewEvents = [Recorded.next(0, ShowEpisodeViewState.loading),
																												Recorded.next(0, ShowEpisodeViewState.showing(episode: nextEpisode))]

		let expectedImageEvents = [Recorded.next(0, ShowEpisodeImageState.loading),
																													Recorded.next(0, ShowEpisodeImageState.image(url: URL(string: "path/to/image.png")!))]

		XCTAssertEqual(results.events, expectedHandleWatchedResults)
		XCTAssertEqual(viewObserver.events, expectedViewEvents)
		XCTAssertEqual(imageObserver.events, expectedImageEvents)

		XCTAssertTrue(self.interactor.toogleWatchInvoked)
	}

	func testShowEpisodeDefaultPresenter_handleWatchedWhenThereIsNoEpisode_onlyCompletes() {
		//Given
		let show = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode()
		setupPresenter(show)

		presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)
		presenter.observeImageState().subscribe(imageObserver).disposed(by: disposeBag)

		presenter.viewDidLoad()

		//When
		let results = scheduler.start { self.presenter.handleWatch().asObservable() }

		//Then
		let expectedHandleWatchedResults: [Recorded<Event<SyncResult>>] = [Recorded.completed(200)]

		let expectedViewEvents = [Recorded.next(0, ShowEpisodeViewState.loading),
																												Recorded.next(0, ShowEpisodeViewState.empty)]

		let expectedImageEvents = [Recorded.next(0, ShowEpisodeImageState.loading),
																													Recorded.next(0, ShowEpisodeImageState.none)]

		XCTAssertEqual(results.events, expectedHandleWatchedResults)
		XCTAssertEqual(viewObserver.events, expectedViewEvents)
		XCTAssertEqual(imageObserver.events, expectedImageEvents)
		XCTAssertFalse(self.interactor.toogleWatchInvoked)
	}
}
