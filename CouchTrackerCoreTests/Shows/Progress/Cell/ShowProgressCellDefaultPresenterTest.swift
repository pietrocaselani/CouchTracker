@testable import CouchTrackerCore
import RxTest
import XCTest

final class ShowProgressCellDefaultPresenterTest: XCTestCase {
  private var interactor: ShowProgressCellMocks.Interactor!
  private var observer: TestableObserver<ShowProgressCellViewState>!
  private var schedulers: TestSchedulers!

  override func setUp() {
    super.setUp()

    schedulers = TestSchedulers()
    observer = schedulers.createObserver(ShowProgressCellViewState.self)
    interactor = ShowProgressCellMocks.Interactor(imageRepository: ImagesRepositorySampleMock())
  }

  func testShowProgressCellDefaultPresenter_receivesViewModelWithoutTMDBId_sendViewModelToView() {
    // Given
    let viewModel = WatchedShowViewModel(title: "Title", nextEpisode: nil, nextEpisodeDate: nil, status: "Returning", tmdbId: nil)

    let presenter = ShowProgressCellDefaultPresenter(interactor: interactor, viewModel: viewModel)

    // When
    _ = presenter.observeViewState().subscribe(observer)
    presenter.viewWillAppear()

    // Then
    let expectedEvents = [Recorded.next(0, ShowProgressCellViewState.viewModel(viewModel: viewModel))]

    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testShowProgressCellDefaultPresenter_receivesViewModelWithTMDBId_sendViewModelAndImageToView() {
    // Given
    let viewModel = WatchedShowViewModel(title: "Title", nextEpisode: nil, nextEpisodeDate: nil, status: "Returning", tmdbId: 1010)

    let presenter = ShowProgressCellDefaultPresenter(interactor: interactor, viewModel: viewModel)

    // When
    _ = presenter.observeViewState().subscribe(observer)
    presenter.viewWillAppear()

    // Then
    let expectedURL = URL(fileURLWithPath: "fake/path/image.png")

    let expectedEvents = [Recorded.next(0, ShowProgressCellViewState.viewModel(viewModel: viewModel)),
                          Recorded.next(0, ShowProgressCellViewState.viewModelAndPosterURL(viewModel: viewModel, url: expectedURL))]
    XCTAssertEqual(observer.events, expectedEvents)
  }

  func testShowProgressCellDefaultPresenter_receivesErrorFromInteractor_doestNotifyView() {
    // Given
    let viewModel = WatchedShowViewModel(title: "Title", nextEpisode: nil, nextEpisodeDate: nil, status: "Returning", tmdbId: 1010)
    let error = NSError(domain: "io.github.pietrocaselani.couchtracker", code: 132, userInfo: nil)
    interactor.imageError = error

    let presenter = ShowProgressCellDefaultPresenter(interactor: interactor, viewModel: viewModel)

    // When
    _ = presenter.observeViewState().subscribe(observer)
    presenter.viewWillAppear()

    // Then
    let expectedEvents = [Recorded.next(0, ShowProgressCellViewState.viewModel(viewModel: viewModel))]
    XCTAssertEqual(observer.events, expectedEvents)
  }
}
