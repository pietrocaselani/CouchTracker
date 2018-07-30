import CouchTrackerCore
import TraktSwift

final class SearchViewModule {
    private init() {}

    static func setupModule(searchTypes: [SearchType], resultOutput: SearchResultOutput) -> BaseView {
        guard let searchView = R.nib.searchBarView.firstView(owner: nil) else {
            Swift.fatalError("searchView can't be nil")
        }

        let trakt = Environment.instance.trakt
        let schedulers = Environment.instance.schedulers

        let reopsitory = SearchAPIRepository(traktProvider: trakt, schedulers: schedulers)
        let interactor = SearchService(repository: reopsitory)
        let presenter = SearchDefaultPresenter(view: searchView,
                                               interactor: interactor,
                                               resultOutput: resultOutput,
                                               types: searchTypes)

        searchView.presenter = presenter

        return searchView
    }
}
