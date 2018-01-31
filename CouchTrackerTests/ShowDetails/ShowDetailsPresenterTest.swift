import XCTest

final class ShowDetailsPresenterTest: XCTestCase {

  private let view = ShowDetailsViewMock()
  private let router = ShowDetailsRouterMock()

  func testShowDetailsPresenterCreation() {
    let interactor = ShowDetailsInteractorMock(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                               repository: showDetailsRepositoryMock,
                                               genreRepository: GenreRepositoryMock(),
                                               imageRepository: imageRepositoryMock)
    let presenter = ShowDetailsiOSPresenter(view: view, router: router, interactor: interactor)
    XCTAssertNotNil(presenter)
  }

  func testShowDetailsPresenter_receivesError_notifyRouter() {
    let errorMessage = "Unknow error"
    let userInfo = [NSLocalizedDescriptionKey: errorMessage]
    let showDetailsError = NSError(domain: "io.github.pietrocaselani", code: 3, userInfo: userInfo)
    let repository = ShowDetailsRepositoryErrorMock(error: showDetailsError)
    let errorInteractor = ShowDetailsInteractorMock(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                                    repository: repository,
                                                    genreRepository: GenreRepositoryMock(),
                                                    imageRepository: imageRepositoryMock)
    let presenter = ShowDetailsiOSPresenter(view: view, router: router, interactor: errorInteractor)

    presenter.viewDidLoad()

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, errorMessage)
  }

  func testShowDetailsPresenter_receivesDetails_notifyView() {
    let interactor = ShowDetailsInteractorMock(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                               repository: showDetailsRepositoryMock,
                                               genreRepository: GenreRepositoryMock(),
                                               imageRepository: imageRepositoryMock)
    let presenter = ShowDetailsiOSPresenter(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    let traktShow = TraktEntitiesMock.createTraktShowDetails()

    let showGenres = TraktEntitiesMock.createShowsGenresMock().filter { genre -> Bool in
      let contains = traktShow.genres?.contains(where: { showGenre -> Bool in
        return genre.slug == showGenre
      })
      return contains ?? false
    }

    let show = ShowEntityMapper.entity(for: traktShow, with: showGenres)
    let genres = show.genres?.map { $0.name }.joined(separator: " | ") ?? ""
    let firstAired = show.firstAired?.parse() ?? "Unknown".localized
    let details = ShowDetailsViewModel(title: show.title ?? "TBA".localized,
                                       overview: show.overview ?? "",
                                       network: show.network ?? "Unknown".localized,
                                       genres: genres,
                                       firstAired: firstAired,
                                       status: show.status?.rawValue.localized ?? "Unknown".localized)

    XCTAssertTrue(view.invokedShowDetails)
    XCTAssertEqual(view.invokedShowDetailsParameters?.details, details)
  }

  func testShowDetailsPresenter_fetchImagesFailure_dontNotifyView() {
    let userInfo = [NSLocalizedDescriptionKey: "Image not found"]
    let imageError = NSError(domain: "io.github.pietrocaselani", code: 404, userInfo: userInfo)

    let interactor = ShowDetailsInteractorMock(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                               repository: showDetailsRepositoryMock,
                                               genreRepository: GenreRepositoryMock(),
                                               imageRepository: ErrorImageRepositoryMock(error: imageError))
    let presenter = ShowDetailsiOSPresenter(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    XCTAssertFalse(view.invokedShowImages)
  }

  func testShowDetailsPresenter_fetchImagesSuccess_notifyView() {
    let interactor = ShowDetailsInteractorMock(showIds: TraktEntitiesMock.createTraktShowDetails().ids,
                                               repository: showDetailsRepositoryMock,
                                               genreRepository: GenreRepositoryMock(),
                                               imageRepository: imageRepositoryRealMock)
    let presenter = ShowDetailsiOSPresenter(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    let posterLink = "https:/image.tmdb.org/t/p/w342/2qg0MOwPD1G0FcYpDPeu6AOjh8i.jpg"
    let backdropLink = "https:/image.tmdb.org/t/p/w300/fZ8j6F8dxZPA8wE5sGS9oiKzXzM.jpg"
    let expectedImagesViewModel = ImagesViewModel(posterLink: posterLink, backdropLink: backdropLink)

    XCTAssertTrue(view.invokedShowImages)
    XCTAssertEqual(view.invokedShowImagesParameters?.images, expectedImagesViewModel)
  }
}
