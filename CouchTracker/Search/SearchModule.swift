import UIKit
import CouchTrackerCore

final class SearchModule {

	private init() {}

	static func setupModule(resultsOutput: SearchResultOutput) -> SearchView {
		guard let searchView = R.nib.searchBarView.firstView(owner: nil) else {
			fatalError("searchView should be an instance of SearchView")
		}

		let environment = Environment.instance

		let store = APISearchRepository(traktProvider: environment.trakt, schedulers: environment.schedulers)
		let interactor = SearchService(repository: store)
		let presenter = SearchDefaultPresenter(view: searchView, interactor: interactor, resultOutput: resultsOutput)

		searchView.presenter = presenter

		return searchView
	}
}
