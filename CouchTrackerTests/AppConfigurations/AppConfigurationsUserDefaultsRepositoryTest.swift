import XCTest
import TraktSwift
import RxTest
import RxSwift

final class AppConfigurationsUserDefaultsRepositoryTest: XCTestCase {
  private let userDefaultsMock = UserDefaults(suiteName: "CouchTrackerTestUserDefaults")!
  private var repository: AppConfigurationsUserDefaultsRepository!
	private var scheduler: TestScheduler!

  override func setUp() {
    repository = AppConfigurationsUserDefaultsRepository(userDefaults: userDefaultsMock, traktProvider: traktProviderMock)
	  scheduler = TestScheduler(initialClock: 0)
	  clearUserDefaults(userDefaultsMock)

	  super.setUp()
  }

  override func tearDown() {
    repository = nil
	  scheduler = nil
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

	func testAppConfigurationsUserDefaultsRepository_fetchLoggedUserWithEmptyCache() {
		//Given an empty repository
		let observer = scheduler.createObserver(User.self)

		//When
		_ = repository.fetchLoggedUser(forced: false).subscribe(observer)
		scheduler.start()

		//Then
		let expectedUser = TraktEntitiesMock.createUserSettingsMock().user
		let expectedEvents: [Recorded<Event<User>>] = [next(0, expectedUser), completed(0)]

		XCTAssertEqual(observer.events, expectedEvents)
	}

	func testAppConfigurationsUserDefaultsRepository_fetchLoggedUserFromAPIAndSaveOnCache() {
		//Given an empty repository
		let observer = scheduler.createObserver(User.self)

		// When
		_ = repository.fetchLoggedUser(forced: false).subscribe(observer)
		scheduler.start()

		//Then
		let expectedSettings = TraktEntitiesMock.createUserSettingsMock()

		let data = userDefaultsMock.data(forKey: "traktUser")!
		let settingsData = try! JSONDecoder().decode(Settings.self, from: data)

		XCTAssertEqual(settingsData, expectedSettings)
	}

	func testAppConfigurationsUserDefaultsRepository_fetchLoggedUserFromCache() {
		//Given
		let settings = TraktEntitiesMock.createUserSettingsMock()
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(TraktDateTransformer.dateTimeTransformer.dateFormatter)

		let data = try! encoder.encode(settings)
		userDefaultsMock.set(data, forKey: "traktUser")

		let repository = AppConfigurationsUserDefaultsRepository(userDefaults: userDefaultsMock, traktProvider: TraktErrorProviderMock())
		let observer = scheduler.createObserver(User.self)

		//When
		_ = repository.fetchLoggedUser(forced: false).subscribe(observer)

		//Then
		let expectedData = userDefaultsMock.data(forKey: "traktUser")!
		let newSettings = try! JSONDecoder().decode(Settings.self, from: expectedData)

		XCTAssertEqual(settings, newSettings)
	}
}
