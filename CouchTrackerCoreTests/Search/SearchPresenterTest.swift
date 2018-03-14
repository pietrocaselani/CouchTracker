import XCTest
import TraktSwift
@testable import CouchTrackerCore

final class SearchPresenterTest: XCTestCase {
	var output: SearchMocks.ResultOutput!
	var view: SearchMocks.View!

	override func setUp() {
		super.setUp()

		output = SearchMocks.ResultOutput()
		view = SearchMocks.View()
	}

	override func tearDown() {
		output = nil
		view = nil

		super.tearDown()
	}

	func testSearchPresenter_viewDidLoad_updateViewHint() {
		let store = SearchMocks.Repository()
		let interactor = SearchService(repository: store)
		let presenter = SearchDefaultPresenter(view: view, interactor: interactor, resultOutput: output, types: [SearchType.movie])

		presenter.viewDidLoad()

		XCTAssertTrue(view.invokedShowHint)
	}

	func testSearchPresenter_performSearchSuccess_outputsTheResults() {
		let searchResultEntities = TraktEntitiesMock.createSearchResultsMock()
		let store = SearchMocks.Repository(results: searchResultEntities)
		let interactor = SearchService(repository: store)
		let presenter = SearchDefaultPresenter(view: view, interactor: interactor, resultOutput: output, types: [SearchType.movie])

		presenter.search(query: "Tron")

		XCTAssertTrue(output.invokedHandleSearch)

		if output.invokedHandleSearchParameters?.results == nil {
			XCTFail("Parameters can't be nil")
		} else {
			XCTAssertEqual(output.invokedHandleSearchParameters!.results, searchResultEntities)
		}
	}

	func testSearchPresenter_performSearchReceivesNoData_notifyOutput() {
		let store = SearchMocks.Repository()
		let interactor = SearchService(repository: store)
		let presenter = SearchDefaultPresenter(view: view, interactor: interactor, resultOutput: output, types: [SearchType.movie])

		presenter.search(query: "Tron")

		XCTAssertTrue(output.invokedHandleEmptySearchResult)
	}

	func testSearchPresenter_performSearchFailure_outputsErrorMessage() {
		let userInfo = [NSLocalizedDescriptionKey: "There is no active connection"]
		let error = NSError(domain: "io.github.pietrocaselani.CouchTracker", code: 10, userInfo: userInfo)
		let store = SearchMocks.ErrorRepository(error: error)
		let interactor = SearchService(repository: store)
		let presenter = SearchDefaultPresenter(view: view, interactor: interactor, resultOutput: output, types: [SearchType.movie])

		presenter.search(query: "Tron")

		let expectedMessage = error.localizedDescription

		XCTAssertTrue(output.invokedHandleError)
		XCTAssertEqual(output.invokedHandleErrorParameters?.message, expectedMessage)
	}

	func testSearchPresenter_performCancel_notifyOutput() {
		let store = SearchMocks.Repository()
		let interactor = SearchService(repository: store)
		let presenter = SearchDefaultPresenter(view: view, interactor: interactor, resultOutput: output, types: [SearchType.movie])

		presenter.cancelSearch()

		XCTAssertEqual(output.searchState, SearchState.notSearching)
	}
}
