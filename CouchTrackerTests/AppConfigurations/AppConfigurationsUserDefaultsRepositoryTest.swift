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
import TraktSwift

final class AppConfigurationsUserDefaultsRepositoryTest: XCTestCase {
  private let userDefaultsMock = UserDefaults(suiteName: "TestUserDefaults")!
  private var repository: AppConfigurationsUserDefaultsRepository!

  override func setUp() {
    clearUserDefaults(userDefaultsMock)
    repository = AppConfigurationsUserDefaultsRepository(userDefaults: userDefaultsMock)
    super.setUp()
  }

  override func tearDown() {
    repository = nil
    super.tearDown()
  }

  private func clearUserDefaults(_ userDefaults: UserDefaults) {
    for (key, _) in userDefaults.dictionaryRepresentation() {
      userDefaults.removeObject(forKey: key)
    }
  }

  func testAppConfigurationsUserDefaultsRepository_emitsAvailableLocales() {
    //Given

    //When
    let single = repository.availableLocales()

    //Then
    let responseExpectation = expectation(description: "Expect all available locales")

    let expectedLocales = Locale.preferredLanguages.map { Locale(identifier: $0) }

    let disposable = single.subscribe(onSuccess: { locales in
      responseExpectation.fulfill()
      XCTAssertEqual(locales, expectedLocales)
    })

    _ = disposeBag.insert(disposable)

    wait(for: [responseExpectation], timeout: 1)
  }

  func testAppConfigurationsUserDefaultsRepository_retrievesEmptyLocale_emitsCurrentLocale() {
    //Given an empty repository

    //When
    let locale = repository.preferredContentLocale

    //Then
    XCTAssertEqual(locale, Locale.current)
  }

  func testAppConfigurationsUserDefaultsRepository_retrivesLocale_emitsSavedLocale() {
    // Given a repository with locale
    userDefaultsMock.set("es_CO", forKey: "preferredLocale")

    //When
    let locale = repository.preferredContentLocale

    //Then
    let expectedLocale = Locale(identifier: "es_CO")
    XCTAssertEqual(locale, expectedLocale)
  }

  func testAppConfigurationsUserDefaultsRepository_updatesLocale() {
    //Given
    userDefaultsMock.set("es_CO", forKey: "preferredLocale")
    let newLocale = Locale(identifier: "th_TH")

    //When
    repository.preferredContentLocale = newLocale

    //Then
    XCTAssertEqual(repository.preferredContentLocale, newLocale)
  }

  func testAppConfigurationsUserDefaultsRepository_retrivesTokenFromEmtyRepository_emmitsTokenAbsentError() {
    //Given an empty repository

    //When
    let token = repository.traktToken

    //Then
    XCTAssertNil(token)
  }

  func testAppConfigurationsUserDefaultsRepository_updatesToken() {
    //Given
    let newToken = AppConfigurationsMock.createTraktTokenMock()

    //When
    repository.traktToken = newToken

    //Then
    XCTAssertEqual(repository.traktToken, newToken)
  }
}
