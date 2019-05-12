@testable import CouchTrackerCore
import RxSwift
import RxTest
import XCTest

final class ShowEpisodeDefaultPresenterTest: XCTestCase {
  private var interactor: ShowEpisodeMocks.Interactor!
  private var presenter: ShowEpisodeDefaultPresenter!
  private var scheduler: TestScheduler!
  private var viewObserver: TestableObserver<ShowEpisodeViewState>!
  private var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()

    interactor = ShowEpisodeMocks.Interactor()
    scheduler = TestScheduler(initialClock: 0)
    disposeBag = DisposeBag()
    viewObserver = scheduler.createObserver(ShowEpisodeViewState.self)
  }

  override func tearDown() {
    presenter = nil
    interactor = nil
    scheduler = nil
    disposeBag = nil
    viewObserver = nil
    super.tearDown()
  }

  private func setupPresenter(_ show: WatchedShowEntity, _ error: Error? = nil, _ emitsImage: Bool = true) {
    interactor.error = error
    interactor.shouldEmitImages = emitsImage
    presenter = ShowEpisodeDefaultPresenter(interactor: interactor, show: show)
  }

  func testShowEpisodeDefaultPresenter_receivesShowWithoutNextEpisode_notifyViewIsEmpty() {
    // Given
    let show = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode()
    setupPresenter(show)

    _ = presenter.observeViewState().subscribe(viewObserver)

    // When
    presenter.viewDidLoad()

    // Then
    let expectedViewEvents = [
      Recorded.next(0, ShowEpisodeViewState.empty),
    ]

    XCTAssertEqual(viewObserver.events, expectedViewEvents)

    XCTAssertFalse(interactor.fetchImageURLInvoked)
    XCTAssertFalse(interactor.toogleWatchInvoked)
  }

  func testShowEpisodeDefaultPresenter_receivesShowWrongImageId_updateViewWithoutImage() {
    // Given
    let show = ShowsProgressMocks.mockWatchedShowEntity()
    let imageError = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 234, userInfo: nil)
    setupPresenter(show, imageError)

    presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

    // When
    presenter.viewDidLoad()

    // Then
    guard let nextEpisode = show.nextEpisode else {
      XCTFail("Next Episode can't be nil")
      return
    }

    let expectedViewEvents = [
      Recorded.next(0, ShowEpisodeViewState.showingEpisode(episode: nextEpisode)),
    ]

    XCTAssertEqual(viewObserver.events, expectedViewEvents)
    XCTAssertTrue(interactor.fetchImageURLInvoked)
  }

  func testShowEpisodeDefaultPresenter_receivesShow_updateViewAndImage() {
    // Given
    let show = ShowsProgressMocks.mockWatchedShowEntity()
    setupPresenter(show)

    presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

    // When
    presenter.viewDidLoad()

    // Then
    guard let nextEpisode = show.nextEpisode else {
      XCTFail("Next Episode can't be nil")
      return
    }

    let imageURL = URL(fileURLWithPath: "path/to/image.png")
    let images = ShowEpisodeImages(posterURL: imageURL, previewURL: imageURL)

    let expectedViewEvents = [
      Recorded.next(0, ShowEpisodeViewState.showing(episode: nextEpisode, images: images)),
    ]

    XCTAssertEqual(viewObserver.events, expectedViewEvents)
    XCTAssertTrue(interactor.fetchImageURLInvoked)
  }

  func testShowEpisodeDefaultPresenter_whenThereIsNoImage_emitCorrectOnlyEpisode() {
    // Given
    let show = ShowsProgressMocks.mockWatchedShowEntity()
    setupPresenter(show, nil, false)

    presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

    // When
    presenter.viewDidLoad()

    guard let nextEpisode = show.nextEpisode else {
      XCTFail("Next Episode can't be nil")
      return
    }

    // Then
    let expectedViewEvents = [
      Recorded.next(0, ShowEpisodeViewState.showingEpisode(episode: nextEpisode)),
    ]

    XCTAssertEqual(viewObserver.events, expectedViewEvents)
  }

  func testShowEpisodeDefaultPresenter_handleWatch_invokesInteractorAndUpdateView() {
    // Given
    let show = ShowsProgressMocks.mockWatchedShowEntity()
    setupPresenter(show)
    let newShow = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode()
    interactor.nextEntity = newShow

    presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    // When
    _ = scheduler.start { self.presenter.handleWatch().asObservable() }

    // Then
    guard let nextEpisode = show.nextEpisode else {
      XCTFail("Next Episode can't be nil")
      return
    }

    let url = URL(fileURLWithPath: "path/to/image.png")
    let images = ShowEpisodeImages(posterURL: url, previewURL: url)

    let expectedViewEvents = [
      Recorded.next(0, ShowEpisodeViewState.showing(episode: nextEpisode, images: images)),
      Recorded.next(200, ShowEpisodeViewState.empty),
    ]

    XCTAssertEqual(viewObserver.events, expectedViewEvents)

    XCTAssertTrue(interactor.toogleWatchInvoked)
    XCTAssertTrue(interactor.fetchImageURLInvoked)
  }

  func testShowEpisodeDefaultPresenter_handleWatchFail_keepViewStateAndEmitError() {
    // Given
    let show = ShowsProgressMocks.mockWatchedShowEntity()
    let watchedError = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 234, userInfo: nil)
    interactor.toogleFailError = watchedError
    setupPresenter(show)

    presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    // When
    let watchedResults = scheduler.start { self.presenter.handleWatch().asObservable() }

    // Then
    let episode = show.nextEpisode!
    let url = URL(fileURLWithPath: "path/to/image.png")
    let images = ShowEpisodeImages(posterURL: url, previewURL: url)

    let expectedViewEvents = [
      Recorded.next(0, ShowEpisodeViewState.showing(episode: episode, images: images)),
    ]

    let watchedEvent: Recorded<Event<Never>> = Recorded.error(200, watchedError)

    XCTAssertEqual(viewObserver.events, expectedViewEvents)
    XCTAssertEqual(watchedResults.events.count, 1)

    let errorEvent = watchedResults.events.first!
    XCTAssertEqual(errorEvent.time, watchedEvent.time)

    guard let errorEventValue = errorEvent.value.error else {
      XCTFail()
      return
    }

    XCTAssertEqual(errorEventValue as NSError, watchedError)

    XCTAssertTrue(interactor.toogleWatchInvoked)
  }

  func testShowEpisodeDefaultPresenter_handleWatchedWhenThereIsNoEpisode_onlyCompletes() {
    // Given
    let show = ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode()
    setupPresenter(show)

    presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    // When
    let results = scheduler.start { self.presenter.handleWatch().asObservable() }

    // Then
    let expectedViewEvents = [
      Recorded.next(0, ShowEpisodeViewState.empty),
    ]

    XCTAssertEqual(viewObserver.events, expectedViewEvents)
    XCTAssertEqual(results.events.count, 1)
    XCTAssertTrue(results.events.first!.value.isCompleted)
    XCTAssertFalse(interactor.toogleWatchInvoked)
  }
}
