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

final class AppConfigurationsInteractorTest: XCTestCase {
  private var disposeBag: CompositeDisposable!

  override func setUp() {
    disposeBag = CompositeDisposable()
    super.setUp()
  }

  override func tearDown() {
    disposeBag.dispose()
    super.tearDown()
  }

  func testAppConfigurationsInteractor_fetchToken_emitsGenericError() {
    //Given
    let message = "decrypt error"
    let genericError = NSError(domain: "com.arctouch", code: 203, userInfo: [NSLocalizedDescriptionKey: message])
    let repository = AppConfigurationsRepositoryErrorMock(error: genericError)
    let interactor = AppConfigurationsService(repository: repository)

    //When
    let single = interactor.traktToken()

    //Then
    let responseExpectation = expectation(description: "Expect error with message: \(message)")

    let disposable = single.subscribe(onError: { error in
      responseExpectation.fulfill()
      XCTAssertEqual(error.localizedDescription, genericError.localizedDescription)
    })

    _ = disposeBag.insert(disposable)

    wait(for: [responseExpectation], timeout: 1)
  }

  func testAppConfigurationsInteractor_fetchToken_emitsTokenError() {
    //Given an empty repository
    let repository = AppConfigurationsRepositoryErrorMock(error: TokenError.absent)
    let interactor = AppConfigurationsService(repository: repository)

    //When
    let single = interactor.traktToken()

    //Then
    let responseExpectation = expectation(description: "Expect result with token error")

    let disposable = single.subscribe(onSuccess: { result in
      responseExpectation.fulfill()
      XCTAssertEqual(result, TokenResult.error(error: TokenError.absent))
    })

    _ = disposeBag.insert(disposable)

    wait(for: [responseExpectation], timeout: 1)
  }

  func testAppConfigurationsInteractor_fetchToken_emmitsTokenSuccess() {
    //Given a repository with token
    let repository = AppConfigurationsRepositoryMock()
    let mockToken = AppConfigurationsMock.createTraktTokenMock()
    repository.appToken = mockToken
    let interactor = AppConfigurationsService(repository: repository)

    //When
    let single = interactor.traktToken()

    //Then
    let responseExpectation = expectation(description: "Expect result with token")

    let disposable = single.subscribe(onSuccess: { result in
      responseExpectation.fulfill()
      XCTAssertEqual(result, TokenResult.logged(token: mockToken, user: "trakt username"))
    })

    _ = disposeBag.insert(disposable)

    wait(for: [responseExpectation], timeout: 1)
  }
}
