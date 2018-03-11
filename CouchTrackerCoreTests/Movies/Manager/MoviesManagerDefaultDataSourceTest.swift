import XCTest

@testable import CouchTrackerCore

final class MoviesManagerDefaultDataSourceTest: XCTestCase {
	private var creator: MoviesManagerMocks.ModuleCreator!
	private var userDefaults: UserDefaults!
	private var dataSource: MoviesManagerDefaultDataSource!

	override func setUp() {
		super.setUp()

		creator = MoviesManagerMocks.ModuleCreator()
		userDefaults = UserDefaults(suiteName: "MoviesManagerDefaultDataSourceTest")
		dataSource = MoviesManagerDefaultDataSource(creator: creator, userDefaults: userDefaults)

		userDefaults.clear()
	}

	override func tearDown() {
		super.tearDown()

		creator = nil
		userDefaults = nil
		dataSource = nil
	}

	func testMoviesManagerDefaultDataSource_returnsOptionsInRightOrder() {
		//Given

		//When
		let options = dataSource.options

		//Then
		let expectedOptions = [MoviesManagerOption.trending]
		XCTAssertEqual(options, expectedOptions)
	}

	func testMoviesManagerDefaultDataSource_returnsModulePagesInRightOrder() {
		//Given

		//When
		let pages = dataSource.modulePages

		//Then
		let expectedPages = [ModulePage(page: BaseViewMock(title: "trending"), title: "Trending")]
		XCTAssertEqual(pages, expectedPages)
	}

	func testMoviesManagerDefaultDataSource_returnsDefaultModuleIndexWhenAbsent() {
		//Given
		XCTAssertNil(userDefaults.object(forKey: "moviesManagerLastTab"))

		//When
		let moduleIndex = dataSource.defaultModuleIndex

		//Then
		let defaultIndex = 0
		XCTAssertEqual(moduleIndex, defaultIndex)
	}

	func testMoviesManagerDefaultDataSource_savesDefaultModuleIndex() {
		//Given

		//When
		dataSource.defaultModuleIndex = 42

		//Then
		XCTAssertEqual(userDefaults.integer(forKey: "moviesManagerLastTab"), 42)
	}

	func testMoviesManagerDefaultDataSource_returnsSavedValue() {
		//Given
		userDefaults.set(92, forKey: "moviesManagerLastTab")

		//When
		let index = dataSource.defaultModuleIndex

		//Then
		XCTAssertEqual(index, 92)
	}
}
