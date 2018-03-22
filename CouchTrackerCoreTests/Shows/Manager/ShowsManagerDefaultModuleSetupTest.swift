import XCTest
@testable import CouchTrackerCore

final class ShowsManagerDefaultModuleSetupTest: XCTestCase {
	private var userDefaults: UserDefaults!
	private var moduleSetup: ShowsManagerDefaultModuleSetup!

	override func setUp() {
		super.setUp()

		userDefaults = UserDefaults(suiteName: "ShowsManagerDefaultModuleSetupTest")
		userDefaults.clear()

		moduleSetup = ShowsManagerDefaultModuleSetup(creator: ShowsManagerCreatorMock(), userDefaults: userDefaults)
	}

	override func tearDown() {
		userDefaults = nil
		moduleSetup = nil

		super.tearDown()
	}

	func testShowsManagerDefaultModuleSetup_provideOptionsInCorrectOrder() {
		//Given

		//When
		let options = moduleSetup.options

		//Then
		let expectedOptions = [ShowsManagerOption.progress, ShowsManagerOption.now, ShowsManagerOption.trending, ShowsManagerOption.search]
		XCTAssertEqual(expectedOptions, options)
	}

	func testShowsManagerDefaultModuleSetup_provideCorrectPages() {
		//Given

		//When
		let pages = moduleSetup.modulePages

		//Then
		let progressPage = ModulePage(page: BaseViewMock(), title: "Progress")
		let nowPage = ModulePage(page: BaseViewMock(), title: "Now")
		let trendingPage = ModulePage(page: BaseViewMock(), title: "Trending")
		let searchPage = ModulePage(page: BaseViewMock(), title: "Search")
		let expectedPages = [progressPage, nowPage, trendingPage, searchPage]

		XCTAssertEqual(expectedPages, pages)
	}

	func testShowsManagerDefaultModuleSetup_returnDefaultIndexCorrect() {
		//Given
		XCTAssertNil(userDefaults.object(forKey: "showsManagerDefaultIndex"))

		//When
		let defaultIndex = moduleSetup.defaultModuleIndex

		//Then
		XCTAssertEqual(defaultIndex, 0)
	}

	func testShowsManagerDefaultModuleSetup_returnDefaultIndexFromUserDefaults() {
		//Given
		userDefaults.set(50, forKey: "showsManagerDefaultIndex")

		//When
		let defaultIndex = moduleSetup.defaultModuleIndex

		//Then
		XCTAssertEqual(defaultIndex, 50)
	}

	func testShowsManagerDefaultModuleSetup_saveNewDefaultIndexOnUserDefaults() {
		//Given
		XCTAssertNil(userDefaults.object(forKey: "showsManagerDefaultIndex"))

		//When
		moduleSetup.defaultModuleIndex = 60

		//Then
		XCTAssertEqual(userDefaults.integer(forKey: "showsManagerDefaultIndex"), 60)
	}
}
