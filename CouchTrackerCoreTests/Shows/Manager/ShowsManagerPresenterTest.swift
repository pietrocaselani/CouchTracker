import XCTest
@testable import CouchTrackerCore

final class ShowsManagerPresenterTest: XCTestCase {
	private let view = ShowsManagerViewMock()
	private var moduleSetup: ShowsManagerDataSourceMock!
	private var presenter: ShowsManagerPresenter!

	private func setup(_ index: Int = 0) {
		let page1 = ModulePage(page: BaseViewMock(), title: "Page1")
		let page2 = ModulePage(page: BaseViewMock(), title: "Page2")
		let page3 = ModulePage(page: BaseViewMock(), title: "Page3")

		moduleSetup = ShowsManagerDataSourceMock(modulePages: [page1, page2, page3], index: index)

		presenter = ShowsManagerDefaultPresenter(view: view, moduleSetup: moduleSetup)
	}

	func testShowsManagerPresenter_initializeWithRightIndex() {
		//Given
		setup(1)

		//When
		presenter.viewDidLoad()

		//Then
		XCTAssertTrue(view.showPagesInvoked)
		XCTAssertEqual(view.showPagesParameters?.index, 1)
		XCTAssertEqual(view.showPagesParameters?.pages.count, 3)
	}
}
