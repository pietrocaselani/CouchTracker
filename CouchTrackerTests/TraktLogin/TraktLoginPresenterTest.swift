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

import RxSwift
import XCTest

final class TraktLoginPresenterTest: XCTestCase {
  private let view = TraktLoginViewMock()
  private let output = TraktLoginOutputMock()

  func testTraktLoginPresenter_fetchLoginURLFails_notifyOutput() {
    //Given
    let message = "Invalid Trakt parameters"
    let userInfo = [NSLocalizedDescriptionKey: message]
    let genericError = NSError(domain: "com.arctouch", code: 50, userInfo: userInfo)
    let interactor = TraktLoginErrorInteractorMock(error: genericError)
    let presenter = TraktLoginiOSPresenter(view: view, interactor: interactor, output: output)

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(output.invokedLogInFail)
    XCTAssertEqual(output.invokedLoginFailParameters?.message, message)
  }

  func testTraktLoginPresenter_fetchLoginURLSuccess_notifyView() {
    //Given
    let url = URL(string: "https://trakt.tv/login")!
    let interactor = TraktLoginInteractorMock(traktProvider: TraktProviderMock(oauthURL: url))
    let presenter = TraktLoginiOSPresenter(view: view, interactor: interactor, output: output)

    //When
    presenter.viewDidLoad()

    //Then
    XCTAssertTrue(view.invokedLoadLogin)
    XCTAssertEqual(view.invokedLoadLoginParameters?.url, url)
  }
}
