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
import RxSwift

final class TraktLoginInteractorTest: XCTestCase {
  private let disposeBag = CompositeDisposable()

  override func tearDown() {
    disposeBag.dispose()
    super.tearDown()
  }

  func testTraktLoginInteractor_createInstanceFailsWithoutOAuthURL() {
    let interactor = TraktLoginService(traktProvider: TraktProviderMock(oauthURL: nil))
    XCTAssertNil(interactor)
  }

  func testTraktLoginInteractor_fetchLoginURLSuccess_emitsURL() {
    //Given
    let url = URL(string: "https://google.com/login")
    let interactor = TraktLoginService(traktProvider: TraktProviderMock(oauthURL: url))!

    //When
    let single = interactor.fetchLoginURL()

    //Then
    let resultExpectation = expectation(description: "Expect login URL")

    let disposable = single.subscribe(onSuccess: { resultURL in
      resultExpectation.fulfill()
      XCTAssertEqual(resultURL, url)
    })
    _ = disposeBag.insert(disposable)

    wait(for: [resultExpectation], timeout: 1)
  }
}
