@testable import CouchTrackerCore
import TraktSwift
import XCTest

final class SearchResultDefaultPresenterTests: XCTestCase {
  private var view: SearchResultMocks.View!
  private var router: SearchResultMocks.Router!
  private var presenter: SearchResultDefaultPresenter!

  override func setUp() {
    super.setUp()
    view = SearchResultMocks.View()
    router = SearchResultMocks.Router()
    presenter = SearchResultDefaultPresenter(view: view, router: router)
  }

  override func tearDown() {
    view = nil
    router = nil
    presenter = nil
    super.tearDown()
  }

  func testSearchResultDefaultPresenter_whenSearchStateChangesToSearching_notifyView() {
    // When
    presenter.searchChangedTo(state: .searching)

    // Then
    XCTAssertTrue(view.invokedShowSearching)
    XCTAssertEqual(view.invokedShowSearchingCount, 1)
  }

  func testSearchResultDefaultPresenter_whenSearchStateChangesToNotSearching_notifyView() {
    // When
    presenter.searchChangedTo(state: .notSearching)

    // Then
    XCTAssertTrue(view.invokedShowNotSearching)
    XCTAssertEqual(view.invokedShowNotSearchingCount, 1)
  }

  func testSearchResultDefaultPresenter_whenThereIsNoResult_notifyView() {
    // When
    presenter.handleEmptySearchResult()

    // Then
    XCTAssertTrue(view.invokedShowEmptyResults)
    XCTAssertEqual(view.invokedShowEmptyResultsCount, 1)
  }

  func testSearchResultDefaultPresenter_whenThereIsAnError_notifyView() {
    // Given
    let errorMessage = "There is no internet connection"

    // When
    presenter.handleError(message: errorMessage)

    // Then
    XCTAssertTrue(view.invokedShowError)
    XCTAssertEqual(view.invokedShowErrorCount, 1)
    XCTAssertEqual(view.invokedShowErrorParameters?.message, errorMessage)
  }

  func testSearchResultDefaultPresenter_whenThereIsShowResults_notifyView() {
    // Given
    let searchResults = [SearchResult.mock(type: .show, movie: nil)]

    // When
    presenter.handleSearch(results: searchResults)

    // Then
    let expectedViewModels = [PosterViewModel(title: "Game of Thrones", type: PosterViewModelType.show(tmdbShowId: 1399))]

    guard let viewModels = view.invokedShowParameters?.viewModels else {
      XCTFail("Parameters can't be nil")
      return
    }

    XCTAssertTrue(view.invokedShow)
    XCTAssertEqual(viewModels, expectedViewModels)
  }

  func testSearchResultsDefaultPresenter_whenThereIsMovieResults_notifyView() {
    // Given
    let searchResults = [SearchResult.mock(type: .movie, show: nil)]

    // When
    presenter.handleSearch(results: searchResults)

    // Then
    let expectedViewModels = [PosterViewModel(title: "TRON: Legacy", type: PosterViewModelType.movie(tmdbMovieId: 20526))]

    guard let viewModels = view.invokedShowParameters?.viewModels else {
      XCTFail("Parameters can't be nil")
      return
    }

    XCTAssertTrue(view.invokedShow)
    XCTAssertEqual(viewModels, expectedViewModels)
  }

  func testSearchResultsDefaultPresenter_whenThereIsMovieAndShowResults_notifyView() {
    // Given
    let showResult = SearchResult.mock(type: .show, movie: nil)
    let movieResult = SearchResult.mock(type: .movie, show: nil)
    let searchResults = [showResult, movieResult]

    // When
    presenter.handleSearch(results: searchResults)

    // Then
    let showViewModel = PosterViewModel(title: "Game of Thrones", type: PosterViewModelType.show(tmdbShowId: 1399))
    let movieViewModel = PosterViewModel(title: "TRON: Legacy", type: PosterViewModelType.movie(tmdbMovieId: 20526))
    let expectedViewModels = [showViewModel, movieViewModel]

    guard let viewModels = view.invokedShowParameters?.viewModels else {
      XCTFail("Parameters can't be nil")
      return
    }

    XCTAssertTrue(view.invokedShow)
    XCTAssertEqual(viewModels, expectedViewModels)
  }
}
