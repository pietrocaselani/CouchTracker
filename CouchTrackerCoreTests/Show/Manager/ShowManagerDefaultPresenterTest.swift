import XCTest

@testable import CouchTrackerCore

final class ShowManagerDefaultPresenterTest: XCTestCase {
	private var view: ShowManagerMocks.View!
	private var dataSource: ShowManagerMocks.DataSource!
	private var presenter: ShowManagerDefaultPresenter!

	override func setUp() {
		super.setUp()

		view = ShowManagerMocks.View()
		dataSource = ShowManagerMocks.DataSource()

		presenter = ShowManagerDefaultPresenter(view: view, dataSource: dataSource)
	}

	override func tearDown() {
		view = nil
		dataSource = nil
		presenter = nil

		super.tearDown()
	}

	func testShowManagerDefaultPresenterTest_viewWasLoaded_shouldUpdateView() {
		//Given

		//When
		presenter.viewDidLoad()

		//Then
		XCTAssertTrue(view.showInvoked)
		XCTAssertTrue(view.titleInvoked)
	}

	func testShowManagerDefaultPresenter_whenSelectTab_shouldNotifyDataSource() {
		//Given
		let newTabSelected = 100

		//When
		presenter.selectTab(index: newTabSelected)

		//Then
		XCTAssertTrue(dataSource.defaultModuleIndexInvoked)
		XCTAssertEqual(dataSource.defaultModuleIndexParameter, newTabSelected)
	}
}
