import XCTest
@testable import CouchTrackerCore

final class ShowsManageriOSModuleSetupTest: XCTestCase {
	func testShowsManageriOSModuleSetup_provideOptionsInCorrectOrder() {
		//Given
		let moduleSetup = ShowsManageriOSModuleSetup(creator: ShowsManagerCreatorMock())

		//When
		let options = moduleSetup.options

		//Then
		let expectedOptions = [ShowsManagerOption.progress, ShowsManagerOption.now, ShowsManagerOption.trending]
		XCTAssertEqual(expectedOptions, options)
	}

	func testShowsManageriOSModuleSetup_provideCorrectPages() {
		//Given
		let moduleSetup = ShowsManageriOSModuleSetup(creator: ShowsManagerCreatorMock())

		//When
		let pages = moduleSetup.modulePages

		//Then
		let progressPage = ModulePage(page: BaseViewMock(), title: "Progress")
		let nowPage = ModulePage(page: BaseViewMock(), title: "Now")
		let trendingPage = ModulePage(page: BaseViewMock(), title: "Trending")
		let expectedPages = [progressPage, nowPage, trendingPage]

		XCTAssertEqual(expectedPages, pages)
	}

	func testShowsManageriOSModuleSetup_returnDefaultIndexCorrect() {
		//Given
		let moduleSetup = ShowsManageriOSModuleSetup(creator: ShowsManagerCreatorMock())

		//When
		let defaultIndex = moduleSetup.defaultModuleIndex

		//Then
		XCTAssertEqual(defaultIndex, 0)
	}
}
