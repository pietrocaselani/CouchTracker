@testable import CouchTrackerCore
import RxSwift
import RxTest
import TraktSwift
import XCTest

final class ShowOverviewPresenterTest: XCTestCase {
  private var genreRepository: GenreRepositoryMock!
  private var scheduler: TestScheduler!
  private var viewObserver: TestableObserver<ShowOverviewViewState>!
  private var imageObserver: TestableObserver<ShowOverviewImagesState>!
  private var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()

    genreRepository = GenreRepositoryMock()
    scheduler = TestScheduler(initialClock: 0)
    disposeBag = DisposeBag()
    viewObserver = scheduler.createObserver(ShowOverviewViewState.self)
    imageObserver = scheduler.createObserver(ShowOverviewImagesState.self)
  }

  override func tearDown() {
    genreRepository = nil
    scheduler = nil
    viewObserver = nil
    imageObserver = nil
    disposeBag = nil

    super.tearDown()
  }

  func testShowOverviewPresenter_receivesError_changeStateToError() {
    let errorMessage = "Unknow error"
    let userInfo = [NSLocalizedDescriptionKey: errorMessage]
    let showDetailsError = NSError(domain: "io.github.pietrocaselani", code: 3, userInfo: userInfo)
    let repository = ShowOverviewRepositoryErrorMock(error: showDetailsError)
    let errorInteractor = ShowOverviewInteractorMock(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                                     repository: repository,
                                                     genreRepository: genreRepository,
                                                     imageRepository: imageRepositoryMock)
    let presenter = ShowOverviewDefaultPresenter(interactor: errorInteractor)

    presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    let expectedEvents = [
      Recorded.next(0, ShowOverviewViewState.loading),
      Recorded.next(0, ShowOverviewViewState.error(error: showDetailsError)),
    ]

    XCTAssertEqual(viewObserver.events, expectedEvents)
  }

  func testShowOverviewPresenter_receivesDetails_changeStateToShowing() {
    let interactor = ShowOverviewInteractorMock(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                                repository: showDetailsRepositoryMock,
                                                genreRepository: genreRepository,
                                                imageRepository: imageRepositoryMock)
    let presenter = ShowOverviewDefaultPresenter(interactor: interactor)

    presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    let traktShow = TraktEntitiesMock.createTraktShowDetails()

    let showGenres = TraktEntitiesMock.createShowsGenresMock().filter { genre -> Bool in
      let contains = traktShow.genres?.contains(where: { showGenre -> Bool in
        genre.slug == showGenre
      })
      return contains ?? false
    }

    let show = ShowEntityMapper.entity(for: traktShow, with: showGenres)

    let expectedEvents = [
      Recorded.next(0, ShowOverviewViewState.loading),
      Recorded.next(0, ShowOverviewViewState.showing(show: show)),
    ]

    XCTAssertEqual(viewObserver.events, expectedEvents)
  }

  func testShowOverviewPresenter_fetchImagesFailure_changeStateToError() {
    let userInfo = [NSLocalizedDescriptionKey: "Image not found"]
    let imageError = NSError(domain: "io.github.pietrocaselani", code: 404, userInfo: userInfo)

    let interactor = ShowOverviewInteractorMock(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                                repository: showDetailsRepositoryMock,
                                                genreRepository: GenreRepositoryMock(),
                                                imageRepository: ErrorImageRepositoryMock(error: imageError))
    let presenter = ShowOverviewDefaultPresenter(interactor: interactor)

    presenter.observeImagesState().subscribe(imageObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    let expectedEvents = [
      Recorded.next(0, ShowOverviewImagesState.loading),
      Recorded.next(0, ShowOverviewImagesState.error(error: imageError)),
    ]

    XCTAssertEqual(imageObserver.events, expectedEvents)
  }

  func testShowOverviewPresenter_fetchImagesSuccess_chageStateToShowing() {
    let interactor = ShowOverviewInteractorMock(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                                repository: showDetailsRepositoryMock,
                                                genreRepository: GenreRepositoryMock(),
                                                imageRepository: imageRepositoryRealMock)
    let presenter = ShowOverviewDefaultPresenter(interactor: interactor)

    presenter.observeImagesState().subscribe(imageObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    let posterLink = "https:/image.tmdb.org/t/p/w342/2qg0MOwPD1G0FcYpDPeu6AOjh8i.jpg"
    let backdropLink = "https:/image.tmdb.org/t/p/w300/fZ8j6F8dxZPA8wE5sGS9oiKzXzM.jpg"
    let expectedImagesViewModel = ImagesViewModel(posterLink: posterLink, backdropLink: backdropLink)

    let expectedEvents = [
      Recorded.next(0, ShowOverviewImagesState.loading),
      Recorded.next(0, ShowOverviewImagesState.showing(images: expectedImagesViewModel)),
    ]

    XCTAssertEqual(imageObserver.events, expectedEvents)
  }

  func testShowOverviewPresenter_noImages_changeStateToEmpty() {
    let showIds = ShowIds(trakt: 0, tmdb: nil, imdb: nil, slug: "", tvdb: 0, tvrage: nil)
    let interactor = ShowOverviewInteractorMock(showIds: showIds,
                                                repository: showDetailsRepositoryMock,
                                                genreRepository: genreRepository,
                                                imageRepository: imageRepositoryMock)
    let presenter = ShowOverviewDefaultPresenter(interactor: interactor)

    presenter.observeImagesState().subscribe(imageObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    let expectedEvents = [
      Recorded.next(0, ShowOverviewImagesState.loading),
      Recorded.next(0, ShowOverviewImagesState.empty),
    ]

    XCTAssertEqual(imageObserver.events, expectedEvents)
  }
}
