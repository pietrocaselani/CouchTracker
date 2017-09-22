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

final class ShowsManagerPresenterTest: XCTestCase {
  private let view = ShowsManagerViewMock()
  private let router = ShowsManagerRouterMock()
  private let moduleSetup = ShowsManageriOSModuleSetup()
  private var presenter: ShowsManagerPresenter!

  private func setupWithLoginState(_ loginState: TraktLoginState) {
    let loginObservable = TraktLoginObservableMock(state: loginState)
    presenter = ShowsManageriOSPresenter(view: view, router: router,
                                         loginObservable: loginObservable, moduleSetup: moduleSetup)
  }

  func testShowsManagerPresenter_notLoggedOnTrakt_notifyRouter() {
    //Given
    setupWithLoginState(.notLogged)

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(router.showNeedsLoginInvoked)
  }

  func testShowsManagerPresenter_loggedInOnTrakt_sentOptionsTitleToView() {
    //Given
    setupWithLoginState(.logged)

    //When
    presenter.viewDidLoad()

    //Then
    let expectedTitles = ["progress", "now"]
    XCTAssertTrue(view.showOptionsSelectionInvoked)
    XCTAssertEqual(view.showOptionsSelectionParameters!, expectedTitles)
  }

  func testShowsManagerPresenter_optionIsSelected_notifyRouter() {
    //Given
    setupWithLoginState(.logged)

    //When
    presenter.viewDidLoad()
    presenter.showOption(at: 1)

    //Then
    XCTAssertTrue(router.showOptionInvoked)
    XCTAssertEqual(router.showOptionParameters, ShowsManagerOption.now)
  }
}
