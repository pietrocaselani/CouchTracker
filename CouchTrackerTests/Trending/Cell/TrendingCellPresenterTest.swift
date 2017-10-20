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

final class TrendingCellPresenterTest: XCTestCase {

  private let view = TrendingCellViewMock()

  func testTrendingCellPresenter_updatesViewModelOnView() {
    let interactor = TrendingCellInteractorMock(imageRepository: imageRepositoryRealMock)
    let trendingViewModel = TrendingViewModel(title: "Nice", type: nil)
    let presenter = TrendingCelliOSPresenter(view: view, interactor: interactor, viewModel: trendingViewModel)

    presenter.viewWillAppear()

    let expectedCellViewModel = TrendingCellViewModel(title: "Nice")

    XCTAssertTrue(view.invokedShowViewModel)
    XCTAssertEqual(view.invokedShowViewModelParameters!.viewModel, expectedCellViewModel)
  }

  func testTrendingCellPresenter_receivesImageURL_notifyView() {
    let interactor = TrendingCellInteractorMock(imageRepository: imageRepositoryRealMock)

    let type = TrendingViewModelType.movie(tmdbMovieId: 4)

    let trendingViewModel = TrendingViewModel(title: "Nice", type: type)
    let presenter = TrendingCelliOSPresenter(view: view, interactor: interactor, viewModel: trendingViewModel)

    presenter.viewWillAppear()

    let expectedURL = URL(string: "https:/image.tmdb.org/t/p/w185/fpemzjF623QVTe98pCVlwwtFC5N.jpg")!

    let realURL = view.invokedPosterImageParameters?.url ?? URL(string: "https://fake.url")!

    XCTAssertTrue(view.invokedShowPosterImage)
    XCTAssertEqual(realURL, expectedURL)
  }
}
