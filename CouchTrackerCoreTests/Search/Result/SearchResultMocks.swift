import CouchTrackerCore
import TraktSwift

final class SearchResultMocks {
	private init() {}

	final class View: SearchResultView {

		var invokedPresenterSetter = false
		var invokedPresenterSetterCount = 0
		var invokedPresenter: SearchResultPresenter?
		var invokedPresenterList = [SearchResultPresenter]()
		var invokedPresenterGetter = false
		var invokedPresenterGetterCount = 0
		var stubbedPresenter: SearchResultPresenter!
		var presenter: SearchResultPresenter! {
			set {
				invokedPresenterSetter = true
				invokedPresenterSetterCount += 1
				invokedPresenter = newValue
				invokedPresenterList.append(newValue)
			}
			get {
				invokedPresenterGetter = true
				invokedPresenterGetterCount += 1
				return stubbedPresenter
			}
		}
		var invokedShow = false
		var invokedShowCount = 0
		var invokedShowParameters: (viewModels: [PosterViewModel], Void)?
		var invokedShowParametersList = [(viewModels: [PosterViewModel], Void)]()

		func show(viewModels: [PosterViewModel]) {
			invokedShow = true
			invokedShowCount += 1
			invokedShowParameters = (viewModels, ())
			invokedShowParametersList.append((viewModels, ()))
		}

		var invokedShowSearching = false
		var invokedShowSearchingCount = 0

		func showSearching() {
			invokedShowSearching = true
			invokedShowSearchingCount += 1
		}

		var invokedShowNotSearching = false
		var invokedShowNotSearchingCount = 0

		func showNotSearching() {
			invokedShowNotSearching = true
			invokedShowNotSearchingCount += 1
		}

		var invokedShowEmptyResults = false
		var invokedShowEmptyResultsCount = 0

		func showEmptyResults() {
			invokedShowEmptyResults = true
			invokedShowEmptyResultsCount += 1
		}

		var invokedShowError = false
		var invokedShowErrorCount = 0
		var invokedShowErrorParameters: (message: String, Void)?
		var invokedShowErrorParametersList = [(message: String, Void)]()

		func showError(message: String) {
			invokedShowError = true
			invokedShowErrorCount += 1
			invokedShowErrorParameters = (message, ())
			invokedShowErrorParametersList.append((message, ()))
		}
	}

	final class Router: SearchResultRouter {
		var invokedShowDetails = false
		var invokedShowDetailsCount = 0
		var invokedShowDetailsParameters: (result: SearchResult, Void)?
		var invokedShowDetailsParametersList = [(result: SearchResult, Void)]()

		func showDetails(of result: SearchResult) {
			invokedShowDetails = true
			invokedShowDetailsCount += 1
			invokedShowDetailsParameters = (result, ())
			invokedShowDetailsParametersList.append((result, ()))
		}
	}
}

