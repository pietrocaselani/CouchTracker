@testable import CouchTrackerCore
import RxSwift
import RxTest
import TraktSwift
import XCTest

final class MovieDetailsPresenterTest: XCTestCase {
  private var genreRepository: GenreRepositoryMock!
  private var scheduler: TestScheduler!
  private var viewObserver: TestableObserver<MovieDetailsViewState>!
  private var imageObserver: TestableObserver<MovieDetailsImagesState>!
  private var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()

    genreRepository = GenreRepositoryMock()
    scheduler = TestScheduler(initialClock: 0)
    disposeBag = DisposeBag()
    viewObserver = scheduler.createObserver(MovieDetailsViewState.self)
    imageObserver = scheduler.createObserver(MovieDetailsImagesState.self)
  }

  override func tearDown() {
    genreRepository = nil
    scheduler = nil
    viewObserver = nil
    imageObserver = nil
    disposeBag = nil

    super.tearDown()
  }

  func testMovieDetailsPresenter_fetchSuccess_andPresentMovieDetails() {
    let movie = TraktEntitiesMock.createUnwatchedMovieDetailsMock()
    let repository = MovieDetailsStoreMock(movie: movie)
    let appConfigsObservable = AppConfigurationsMock.AppConfigurationsObservableMock()
    let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
                                             imageRepository: imageRepositoryRealMock, movieIds: movie.ids)
    let presenter = MovieDetailsDefaultPresenter(interactor: interactor, appConfigObservable: appConfigsObservable)

    presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    let genres = TraktEntitiesMock.createMoviesGenresMock()
    let movieGenres = genres.filter { movie.genres?.contains($0.slug) ?? false }

    let movieEntity = MovieEntityMapper.entity(for: movie, with: movieGenres, watchedAt: nil)

    let viewStateLoading = MovieDetailsViewState.loading
    let viewStateShowing = MovieDetailsViewState.showing(movie: movieEntity)

    let expectedViewStateEvents = [
      next(0, viewStateLoading),
      next(0, viewStateShowing),
    ]
    XCTAssertEqual(viewObserver.events, expectedViewStateEvents)
  }

  func testMovieDetailsPresenter_fetchWatchedMovieDetails_notifyView() {
    let movie = TraktEntitiesMock.createMovieDetailsMock()
    let repository = MovieDetailsStoreMock(movie: movie)
    let appConfigsObservable = AppConfigurationsMock.AppConfigurationsObservableMock()
    let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
                                             imageRepository: imageRepositoryRealMock, movieIds: movie.ids)
    let presenter = MovieDetailsDefaultPresenter(interactor: interactor, appConfigObservable: appConfigsObservable)

    presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    let genres = TraktEntitiesMock.createMoviesGenresMock()
    let movieGenres = genres.filter { movie.genres?.contains($0.slug) ?? false }
    let watchedAt = TraktDateTransformer.dateTimeTransformer.dateFormatter.date(from: "2013-06-15T05:54:27.000Z")

    let movieEntity = MovieEntityMapper.entity(for: movie, with: movieGenres, watchedAt: watchedAt)

    let viewStateLoading = MovieDetailsViewState.loading
    let viewStateShowing = MovieDetailsViewState.showing(movie: movieEntity)

    let expectedViewStateEvents = [
      next(0, viewStateLoading),
      next(0, viewStateShowing),
    ]
    XCTAssertEqual(viewObserver.events, expectedViewStateEvents)
  }

  func testMovieDetailsPresenter_fetchImagesSuccess_andNotifyView() {
    let movie = TraktEntitiesMock.createMovieMock(for: "the-dark-knight-2008")
    let repository = MovieDetailsStoreMock(movie: movie)
    let appConfigsObservable = AppConfigurationsMock.AppConfigurationsObservableMock()
    let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
                                             imageRepository: imageRepositoryRealMock, movieIds: movie.ids)
    let presenter = MovieDetailsDefaultPresenter(interactor: interactor, appConfigObservable: appConfigsObservable)

    presenter.observeImagesState().subscribe(imageObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    let posterLink = "https:/image.tmdb.org/t/p/w342/fpemzjF623QVTe98pCVlwwtFC5N.jpg"
    let backdropLink = "https:/image.tmdb.org/t/p/w300/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"
    let viewModel = ImagesViewModel(posterLink: posterLink, backdropLink: backdropLink)

    let expectedImagesEvents = [
      next(0, MovieDetailsImagesState.loading),
      next(0, MovieDetailsImagesState.showing(images: viewModel)),
    ]

    XCTAssertEqual(imageObserver.events, expectedImagesEvents)
  }

  func testMovieDetailsPresenter_fetchImagesFailure_andNotifyView() {
    let movie = TraktEntitiesMock.createMovieMock(for: "the-dark-knight-2008")
    let repository = MovieDetailsStoreMock(movie: movie)

    let json = "{\"trakt\": 4,\"slug\": \"the-dark-knight-2008\",\"imdb\": \"tt0468569\",\"tmdb\": null}".data(using: .utf8)!

    let movieIds = try! JSONDecoder().decode(MovieIds.self, from: json)
    let appConfigsObservable = AppConfigurationsMock.AppConfigurationsObservableMock()

    let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
                                             imageRepository: imageRepositoryRealMock, movieIds: movieIds)
    let presenter = MovieDetailsDefaultPresenter(interactor: interactor, appConfigObservable: appConfigsObservable)

    presenter.observeImagesState().subscribe(imageObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    let expectedError = MovieDetailsError.noImageAvailable
    let expectedEvents = [
      next(0, MovieDetailsImagesState.loading),
      next(0, MovieDetailsImagesState.error(error: expectedError)),
    ]

    XCTAssertEqual(imageObserver.events, expectedEvents)
  }

  func testMovieDetailsPresenter_fetchFailure_andPresentErrorMessage() {
    let movie = TraktEntitiesMock.createMovieDetailsMock()
    let errorMessage = "There is no active connection"
    let detailsError = MovieDetailsError.noConnection(errorMessage)
    let appConfigsObservable = AppConfigurationsMock.AppConfigurationsObservableMock()
    let repository = ErrorMovieDetailsStoreMock(error: detailsError)
    let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
                                             imageRepository: imageRepositoryMock, movieIds: movie.ids)
    let presenter = MovieDetailsDefaultPresenter(interactor: interactor, appConfigObservable: appConfigsObservable)

    presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    let expectedError = MovieDetailsError.noConnection(errorMessage)
    let expectedEvents = [
      next(0, MovieDetailsViewState.loading),
      next(0, MovieDetailsViewState.error(error: expectedError)),
    ]

    XCTAssertEqual(viewObserver.events, expectedEvents)
  }

  func testMovieDetailsPresenter_fetchFailure_andIsCustomError() {
    let appConfigsObservable = AppConfigurationsMock.AppConfigurationsObservableMock()
    let movie = TraktEntitiesMock.createMovieDetailsMock()
    let errorMessage = "Custom details error"
    let error = NSError(domain: "io.github.pietrocaselani.CouchTracker", code: 10, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    let repository = ErrorMovieDetailsStoreMock(error: error)
    let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
                                             imageRepository: imageRepositoryMock, movieIds: movie.ids)
    let presenter = MovieDetailsDefaultPresenter(interactor: interactor, appConfigObservable: appConfigsObservable)

    presenter.observeViewState().subscribe(viewObserver).disposed(by: disposeBag)

    presenter.viewDidLoad()

    let expectedEvents = [
      next(0, MovieDetailsViewState.loading),
      next(0, MovieDetailsViewState.error(error: error)),
    ]

    XCTAssertEqual(viewObserver.events, expectedEvents)
  }

  func testMovieDetailsPresenter_handleWatchedWhenNotLogged_emitError() {
    let appConfigsObservable = AppConfigurationsMock.AppConfigurationsObservableMock()
    let interactor = MovieDetailsMocks.Interactor()
    let presenter = MovieDetailsDefaultPresenter(interactor: interactor, appConfigObservable: appConfigsObservable)
    presenter.viewDidLoad()

    let observer = scheduler.createObserver(Never.self)

    presenter.handleWatched().asObservable().subscribe(observer).disposed(by: disposeBag)

    XCTAssertEqual(interactor.toggleWatchedInvokedCount, 0)
    XCTAssertEqual(observer.events.count, 1)

    guard let error = observer.events.first?.value.error as? CouchTrackerCore.TraktError else {
      XCTFail("Should be instance of TraktError")
      return
    }

    XCTAssertEqual(error, CouchTrackerCore.TraktError.loginRequired)
  }

  func testMovieDetailsPresenter_handleWatchedWhenViewStateIsNotShowing_onlyCompletes() {
    let movie = TraktEntitiesMock.createMovieDetailsMock()
    let errorMessage = "There is no active connection"
    let detailsError = MovieDetailsError.noConnection(errorMessage)
    let appConfigsObservable = AppConfigurationsMock.AppConfigurationsObservableMock()
    let repository = ErrorMovieDetailsStoreMock(error: detailsError)
    let interactor = MovieDetailsServiceMock(repository: repository, genreRepository: genreRepository,
                                             imageRepository: imageRepositoryMock, movieIds: movie.ids)
    let presenter = MovieDetailsDefaultPresenter(interactor: interactor, appConfigObservable: appConfigsObservable)
    presenter.viewDidLoad()

    let observer = scheduler.createObserver(Never.self)

    presenter.handleWatched().asObservable().subscribe(observer).disposed(by: disposeBag)

    XCTAssertEqual(interactor.toggleWatchedInvokedCount, 0)
    XCTAssertEqual(observer.events.count, 1)

    guard let event = observer.events.first else {
      XCTFail()
      return
    }

    XCTAssertTrue(event.value.isCompleted)
  }

  func testMovieDetailsPresenter_handleWatched_notifyInteractor() {
    let appConfigsObservable = AppConfigurationsMock.AppConfigurationsObservableMock()
    let interactor = MovieDetailsMocks.Interactor()
    let presenter = MovieDetailsDefaultPresenter(interactor: interactor, appConfigObservable: appConfigsObservable)
    let newState = AppConfigurationsState(loginState: LoginState.logged(settings: TraktEntitiesMock.createUserSettingsMock()), hideSpecials: false)
    presenter.viewDidLoad()

    appConfigsObservable.change(state: newState)

    let observer = scheduler.createObserver(Never.self)

    presenter.handleWatched().asObservable().subscribe(observer).disposed(by: disposeBag)

    XCTAssertEqual(interactor.toggleWatchedInvokedCount, 1)
    XCTAssertEqual(observer.events.count, 1)

    guard let event = observer.events.first else {
      XCTFail()
      return
    }

    XCTAssertTrue(event.value.isCompleted)
  }
}
