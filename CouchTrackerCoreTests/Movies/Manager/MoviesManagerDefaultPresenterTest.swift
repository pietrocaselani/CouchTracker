import XCTest

@testable import CouchTrackerCore

final class MoviesManagerDefaultPresenterTest: XCTestCase {
	private var view: MoviesManagerMocks.View!
	private var dataSource: MoviesManagerMocks.DataSource!
	private var presenter: MoviesManagerDefaultPresenter!

	override func setUp() {
		super.setUp()

		let creator = MoviesManagerMocks.ModuleCreator()

		view = MoviesManagerMocks.View()
		dataSource = MoviesManagerMocks.DataSource(creator: creator)
		presenter = MoviesManagerDefaultPresenter(view: view, dataSource: dataSource)
	}

	override func tearDown() {
		view = nil
		dataSource = nil
		presenter = nil

		super.tearDown()
	}

	func testMoviesManagerDefaultPresenter_whenViewIsLoaded_updateView() {
		//Given

		//When
		presenter.viewDidLoad()

		//Then
		XCTAssertTrue(view.showPagesInvoked)

		guard let parameters = view.showPagesParameters else {
			XCTFail("Parameters can't be nil")
			return
		}

		XCTAssertEqual(parameters.index, 2)
		XCTAssertEqual(parameters.pages, [ModulePage(page: BaseViewMock(title: "Trending"), title: "Trending")])
	}
}
