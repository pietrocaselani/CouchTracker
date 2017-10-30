import XCTest
import TraktSwift

final class AppConfigurationsUserDefaultsRepositoryTest: XCTestCase {
  private let userDefaultsMock = UserDefaults(suiteName: "TestUserDefaults")!
  private var repository: AppConfigurationsUserDefaultsRepository!

  override func setUp() {
    clearUserDefaults(userDefaultsMock)
    repository = AppConfigurationsUserDefaultsRepository(userDefaults: userDefaultsMock, traktProvider: traktProviderMock)
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
    let locales = repository.preferredLocales

    //Then
    let expectedLocales = Locale.preferredLanguages.map { Locale(identifier: $0) }
    XCTAssertEqual(locales, expectedLocales)
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
}
