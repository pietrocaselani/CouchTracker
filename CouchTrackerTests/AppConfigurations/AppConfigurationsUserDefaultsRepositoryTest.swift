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
import TraktSwift

final class AppConfigurationsUserDefaultsRepositoryTest: XCTestCase {
  private let userDefaultsMock = UserDefaults(suiteName: "TestUserDefaults")!
  private var repository: AppConfigurationsUserDefaultsRepository!
  private var disposeBag: CompositeDisposable!

  override func setUp() {
    clearUserDefaults(userDefaultsMock)
    disposeBag = CompositeDisposable()
    repository = AppConfigurationsUserDefaultsRepository(userDefaults: userDefaultsMock)
    super.setUp()
  }

  override func tearDown() {
    repository = nil
    disposeBag.dispose()
    super.tearDown()
  }

  private func clearUserDefaults(_ userDefaults: UserDefaults) {
    for (key, _) in userDefaults.dictionaryRepresentation() {
      userDefaults.removeObject(forKey: key)
    }
  }

  func testAppConfigurationsUserDefaultsRepository_retrievesEmptyLocale_emitsCurrentLocale() {
    //Given an empty repository

    //When
    let single = repository.preferredContentLocale()

    //Then
    let responseExpectation = expectation(description: "Expect for current locale")

    let disposable = single.subscribe(onSuccess: { locale in
      responseExpectation.fulfill()
      XCTAssertEqual(locale, Locale.current)
    })

    _ = disposeBag.insert(disposable)

    wait(for: [responseExpectation], timeout: 1)
  }

  func testAppConfigurationsUserDefaultsRepository_retrivesLocale_emitsSavedLocale() {
    // Given a repository with locale
    userDefaultsMock.set("es_CO", forKey: "preferredLocale")

    //When
    let single = repository.preferredContentLocale()

    //Then
    let responseExpectation = expectation(description: "Expect locale to be Spanish (Colombia)")
    let expectedLocale = Locale(identifier: "es_CO")

    let disposable = single.subscribe(onSuccess: { locale in
      responseExpectation.fulfill()
      XCTAssertEqual(locale, expectedLocale)
    })

    _ = disposeBag.insert(disposable)

    wait(for: [responseExpectation], timeout: 1)
  }

  func testAppConfigurationsUserDefaultsRepository_updatesLocale() {
    //Given
    userDefaultsMock.set("es_CO", forKey: "preferredLocale")
    let newLocale = Locale(identifier: "th_TH")

    //When
    let completable = repository.updatePreferredContent(locale: newLocale)

    //Then
    let responseExpcetation = expectation(description: "Expect on completed event")

    let disposable = completable.subscribe(onCompleted: { [unowned self] in
      responseExpcetation.fulfill()

      let disposable = self.repository.preferredContentLocale().subscribe(onSuccess: { locale in
        XCTAssertEqual(locale, newLocale)
      })
      _ = self.disposeBag.insert(disposable)
    })

    _ = disposeBag.insert(disposable)

    wait(for: [responseExpcetation], timeout: 1)
  }

  func testAppConfigurationsUserDefaultsRepository_retrivesTokenFromEmtyRepository_emmitsTokenAbsentError() {
    //Given an empty repository

    //When
    let single = repository.traktToken()

    //Then
    let responseExpectation = expectation(description: "Expect token absent error")

    let disposable = single.subscribe(onSuccess: nil) { error in
      responseExpectation.fulfill()
      XCTAssert(error is TokenError)
      XCTAssertEqual(error as! TokenError, TokenError.absent)
    }

    _ = disposeBag.insert(disposable)

    wait(for: [responseExpectation], timeout: 1)
  }

  func testAppConfigurationsUserDefaultsRepository_updatesToken() {
    //Given
    let date = Date(timeIntervalSince1970: 5)
    let newToken = Token(accessToken: "accessToken1", expiresIn: date,
                         refreshToken: "refresh1", tokenType: "type1", scope: "general")

    //When
    let completable = repository.updateTrakt(token: newToken)

    //Then
    let responseExpectation = expectation(description: "Expect to save the new token")

    let disposable = completable.subscribe(onCompleted: { [unowned self] in
      responseExpectation.fulfill()
      let anotherDisposable = self.repository.traktToken().subscribe(onSuccess: { savedToken in
        XCTAssertEqual(savedToken, newToken)
      })
      _ = self.disposeBag.insert(anotherDisposable)
    })

    _ = self.disposeBag.insert(disposable)

    wait(for: [responseExpectation], timeout: 1)
  }
}
