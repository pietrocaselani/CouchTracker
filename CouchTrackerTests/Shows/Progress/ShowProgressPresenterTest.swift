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

final class ShowsProgressPresenterTest: XCTestCase {
  private let view = ShowsProgressMocks.ShowsProgressViewMock()
  private let repository = ShowsProgressMocks.ShowsProgressRepositoryMock(trakt: traktProviderMock, cache: AnyCache(CacheMock()))
  private let dataSource = ShowsProgressMocks.ShowProgressDataSourceMock()

  func testShowsProgressPresenter_receivesEmptyData_notifyView() {
    //Given
    let interactor = ShowsProgressMocks.EmptyShowsProgressInteractorMock(repository: repository)
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor, dataSource: dataSource)

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(view.showEmptyViewInvoked)
    XCTAssertTrue(view.updateFinishedInvoked)
    XCTAssertEqual(dataSource.viewModelCount(), 0)
  }

  func testShowsProgressPresenter_receivesData_notifyView() {
    //Given
    let interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository)
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor, dataSource: dataSource)

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(view.newViewModelAvailableInvoked)
    XCTAssertEqual(view.newViewModelAvailableParameters, [0, 1, 2])
    XCTAssertTrue(view.updateFinishedInvoked)
    XCTAssertEqual(dataSource.viewModelCount(), 3)
  }

  func testShowsProgressPresenter_forceUpdate_reloadView() {
    //Given
    let interactor = ShowsProgressMocks.ShowsProgressInteractorMock(repository: repository)
    let presenter = ShowsProgressiOSPresenter(view: view, interactor: interactor, dataSource: dataSource)
    presenter.viewDidLoad()

    //When
    presenter.updateShows()

    //Then
    XCTAssertTrue(view.newViewModelAvailableInvoked)
    XCTAssertEqual(view.newViewModelAvailableParameters, [0, 1, 2, 0, 1, 2])
    XCTAssertTrue(view.updateFinishedInvoked)
    XCTAssertEqual(dataSource.viewModelCount(), 3)
  }
}
