import XCTest
import TraktSwift

final class SearchPresenterTest: XCTestCase {
  let output = SearchResultOutputMock()
  let view = SearchViewMock()

  func testSearchPresenter_viewDidLoad_updateViewHint() {
    let store = EmptySearchStoreMock()
    let interactor = SearchService(repository: store)
    let presenter = SearchiOSPresenter(view: view, interactor: interactor, resultOutput: output)

    presenter.viewDidLoad()

    XCTAssertTrue(view.invokedShowHint)
  }

  func testSearchPresenter_performSearchSuccess_outputsTheResults() {
    let searchResultEntities = TraktEntitiesMock.createSearchResultsMock()
    let store = SearchStoreMock(results: searchResultEntities)
    let interactor = SearchService(repository: store)
    let presenter = SearchiOSPresenter(view: view, interactor: interactor, resultOutput: output)

    presenter.searchMovies(query: "Tron")

    XCTAssertTrue(output.invokedHandleSearch)

    if output.invokedHandleSearchParameters?.results == nil {
      XCTFail("Parameters can't be nil")
    } else {
      XCTAssertEqual(output.invokedHandleSearchParameters!.results, searchResultEntities)
    }
  }

  func testSearchPresenter_performSearchReceivesNoData_notifyOutput() {
    let store = SearchStoreMock(results: [SearchResult]())
    let interactor = SearchService(repository: store)
    let presenter = SearchiOSPresenter(view: view, interactor: interactor, resultOutput: output)

    presenter.searchMovies(query: "Tron")

    XCTAssertTrue(output.invokedHandleEmptySearchResult)
  }

  func testSearchPresenter_performSearchFailure_outputsErrorMessage() {
    let userInfo = [NSLocalizedDescriptionKey: "There is no active connection"]
    let error = NSError(domain: "io.github.pietrocaselani.CouchTracker", code: 10, userInfo: userInfo)
    let store = ErrorSearchStoreMock(error: error)
    let interactor = SearchService(repository: store)
    let presenter = SearchiOSPresenter(view: view, interactor: interactor, resultOutput: output)

    presenter.searchMovies(query: "Tron")

    let expectedMessage = error.localizedDescription

    XCTAssertTrue(output.invokedHandleError)
    XCTAssertEqual(output.invokedHandleErrorParameters?.message, expectedMessage)
  }

  func testSearchPresenter_performCancel_notifyOutput() {
    let store = EmptySearchStoreMock()
    let interactor = SearchService(repository: store)
    let presenter = SearchiOSPresenter(view: view, interactor: interactor, resultOutput: output)

    presenter.cancelSearch()

    XCTAssertEqual(output.searchState, SearchState.notSearching)
  }
}
