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

import Moya
import ObjectMapper
import XCTest
import Trakt_Swift
import RxTest

final class TrendingPresenterTest: XCTestCase {

  private let scheduler = TestScheduler(initialClock: 0)
  let view = TrendingViewMock()
  let router = TrendingRouterMock()

  func testTrendingPresenter_fetchSuccessWithEmptyData_andPresentNoMovies() {
    let repository = EmptyListMoviesStoreMock()
    let interactor = TrendingServiceMock(repository: repository, imageRepository: movieImageRepositoryMock)
    let presenter = TrendingiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchTrending(of: .movies)

    XCTAssertTrue(view.invokedShowEmptyView)
    XCTAssertFalse(view.invokedShow)
  }

  func testTrendingPresenter_fetchFailure_andPresentError() {
    let error = TrendingError.parseError("Invalid json")
    let repository = ErrorTrendingRepositoryMock(error: error)
    let interactor = TrendingServiceMock(repository: repository, imageRepository: movieImageRepositoryMock)
    let presenter = TrendingiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchTrending(of: .movies)

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, "Invalid json")
  }

  func testTrendingPresenter_fetchSuccess_andPresentMovies() {
    let movies = createMockMovies()
    let images = createImagesEntityMock()
    let repository = TrendingMoviesRepositoryMock(movies: movies)
    let interactor = TrendingServiceMock(repository: repository, imageRepository: createMovieImagesRepositoryMock(images))
    let presenter = TrendingiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchTrending(of: .movies)

    let link = images.posterImage()?.link

    let expectedViewModel = movies.map { TrendingViewModel(title: $0.movie.title ?? "TBA", imageLink: link) }

    XCTAssertTrue(view.invokedShow)
    XCTAssertEqual(view.invokedShowParameters!.movies, expectedViewModel)
  }

  func testTrendingPresenter_fetchSuccess_andPresentNoMovies() {
    let movies = [TrendingMovie]()
    let images = createImagesEntityMock()
    let repository = TrendingMoviesRepositoryMock(movies: movies)
    let interactor = TrendingServiceMock(repository: repository, imageRepository: createMovieImagesRepositoryMock(images))

    let presenter = TrendingiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchTrending(of: .movies)

    XCTAssertTrue(view.invokedShowEmptyView)
    XCTAssertFalse(view.invokedShow)
  }

  func testTrendingPresenter_fetchFailure_andIsCustomError() {
    let userInfo = [NSLocalizedDescriptionKey: "Custom list movies error"]
    let error = NSError(domain: "com.arctouch.CouchTracker", code: 10, userInfo: userInfo)
    let interactor = TrendingServiceMock(repository: ErrorTrendingRepositoryMock(error: error), imageRepository: movieImageRepositoryMock)

    let presenter = TrendingiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchTrending(of: .movies)

    XCTAssertTrue(router.invokedShowError)
    XCTAssertEqual(router.invokedShowErrorParameters?.message, "Custom list movies error")
  }

  func testTrendingPresenter_requestToShowDetails_notifyRouterToShowDetails() {
    let movieIndex = 1
    let movies = createMockMovies()
    let images =  createImagesEntityMock()
    let repository = TrendingMoviesRepositoryMock(movies: movies)
    let interactor = TrendingServiceMock(repository: repository, imageRepository: createMovieImagesRepositoryMock(images))
    let presenter = TrendingiOSPresenter(view: view, interactor: interactor, router: router)

    presenter.fetchTrending(of: .movies)
    presenter.showDetailsOfMovie(at: movieIndex)

    let expectedMovie = entity(for: movies[movieIndex], with: images)

    XCTAssertTrue(router.invokedShowDetails)
    XCTAssertEqual(router.invokedShowDetailsParameters?.movie, expectedMovie)
  }
}
