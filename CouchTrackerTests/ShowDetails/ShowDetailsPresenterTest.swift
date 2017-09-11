/*
Copyright 2017 ArcTouch LLC.
All rights reserved.
 
This file, its contents, concepts, methods, behavior, and operation
(collectively the "Software") are protected by trade secret, patent,
and copyright laws. The use of the Software is governed by a license
agreement. Disclosure of the Software to third parties, in any form,
in whole or in part, is expressly prohibited except as authorized by
the license agreement.
*/

import XCTest

final class ShowDetailsPresenterTest: XCTestCase {

  private let view = ShowDetailsViewMock()
  private let router = ShowDetailsRouterMock()

  func testShowDetailsPresenterCreation() {
    let interactor = ShowDetailsInteractorMock(showId: "game-of-thrones", repository: showDetailsRepositoryMock, genreRepository: GenreRepositoryMock())
    let presenter = ShowDetailsiOSPresenter(view: view, router: router, interactor: interactor)
    XCTAssertNotNil(presenter)
  }

  func testShowDetailsPresenter_receivesError_notifyRouter() {
    let errorMessage = "Unknow error"
    let userInfo = [NSLocalizedDescriptionKey: errorMessage]
    let showDetailsError = NSError(domain: "com.arctouch", code: 3, userInfo: userInfo)
    let repository = ShowDetailsRepositoryErrorMock(error: showDetailsError)
    let errorInteractor = ShowDetailsInteractorMock(showId: "game-of-thrones", repository: repository, genreRepository: GenreRepositoryMock())
    let presenter = ShowDetailsiOSPresenter(view: view, router: router, interactor: errorInteractor)

    presenter.viewDidLoad()

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, errorMessage)
  }

  func testShowDetailsPresenter_receivesDetails_notifyView() {
    let interactor = ShowDetailsInteractorMock(showId: "game-of-thrones", repository: showDetailsRepositoryMock, genreRepository: GenreRepositoryMock())
    let presenter = ShowDetailsiOSPresenter(view: view, router: router, interactor: interactor)

    presenter.viewDidLoad()

    let traktShow = createTraktShowDetails()

    let showGenres = createShowsGenresMock().filter { genre -> Bool in
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
}
