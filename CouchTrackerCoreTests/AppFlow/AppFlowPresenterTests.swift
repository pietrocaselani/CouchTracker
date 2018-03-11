import XCTest
@testable import CouchTrackerCore

final class AppFlowPresenterTests: XCTestCase {
	private var view: AppFlowMocks.View!
	private var interactor: AppFlowMocks.Interactor!
	private var dataSource: AppFlowMocks.ModuleDataSource!
	private var presenter: AppFlowDefaultPresenter!

	override func setUp() {
		super.setUp()

		view = AppFlowMocks.View()
		interactor = AppFlowMocks.Interactor()
		dataSource = AppFlowMocks.ModuleDataSource()
		presenter = AppFlowDefaultPresenter(view: view, interactor: interactor, moduleDataSource: dataSource)
	}

	override func tearDown() {
		super.tearDown()

		view = nil
		interactor = nil
		dataSource = nil
		presenter = nil
	}

	func testAppFlowPresenter_viewDidLoad_shouldNotifyView() {
		//Given
		interactor.lastSelectedTab = 2

		//When
		presenter.viewDidLoad()

		//Then
		XCTAssertTrue(view.showPagesInvoked)

		guard let parameters = view.showPagesParameters else {
			XCTFail("Parameters can't be nil")
			return
		}

		XCTAssertEqual(parameters.selectedIndex, 2)
		XCTAssertTrue(parameters.pages.count >= 3)
		XCTAssertTrue(interactor.lastSelectedTabInvoked)
		XCTAssertTrue(dataSource.modulePagesInvoked)
	}

	func testAppFlowPresenter_receivesNewTabSelected_shouldNotifyInteractor() {
		//Given
		interactor.lastSelectedTab = 1

		//When
		presenter.selectTab(index: 2)

		//Then
		XCTAssertEqual(interactor.lastSelectedTab, 2)
	}
}
