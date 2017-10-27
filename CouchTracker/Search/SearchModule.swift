import UIKit

final class SearchModule {

  private init() {}

  static func setupModule(traktProvider: TraktProvider, resultsOutput: SearchResultOutput) -> SearchView {
    guard let searchView = R.nib.searchBarView.firstView(owner: nil) else {
      fatalError("searchView should be an instance of SearchView")
    }

    let store = APISearchRepository(traktProvider: traktProvider)
    let interactor = SearchService(repository: store)
    let presenter = SearchiOSPresenter(view: searchView, interactor: interactor, resultOutput: resultsOutput)

    searchView.presenter = presenter

    return searchView
  }
}
