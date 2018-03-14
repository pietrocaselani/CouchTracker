import Moya
import RxSwift
import TraktSwift
@testable import CouchTrackerCore

final class SearchMocks {
	private init() {}

	final class View: SearchView {
		var presenter: SearchPresenter!
		var invokedShowHint = false
		var invokedShowHintParameters: (message: String, Void)?

		func showHint(message: String) {
			invokedShowHint = true
			invokedShowHintParameters = (message, ())
		}
	}

	final class ResultOutput: SearchResultOutput {
		var invokedHandleEmptySearchResult = false
		var invokedHandleSearch = false
		var invokedHandleSearchParameters: (results: [SearchResult], Void)?
		var invokedHandleError = false
		var invokedHandleErrorParameters: (message: String, Void)?
		var searchChangedToInvoked = false
		var searchChangedToInvokedCount = 0
		var searchState = SearchState.notSearching

		func handleEmptySearchResult() {
			invokedHandleEmptySearchResult = true
		}

		func handleSearch(results: [SearchResult]) {
			invokedHandleSearch = true
			invokedHandleSearchParameters = (results, ())
		}

		func handleError(message: String) {
			invokedHandleError = true
			invokedHandleErrorParameters = (message, ())
		}

		func searchChangedTo(state: SearchState) {
			searchChangedToInvoked = true
			searchChangedToInvokedCount += 1
			searchState = state
		}
	}

	final class ErrorRepository: SearchRepository {
		var searchInvoked = false
		var searchParameters: (query: String, types: [SearchType], page: Int, limit: Int)?
		private let error: Swift.Error

		init(error: Swift.Error) {
			self.error = error
		}

		func search(query: String, types: [SearchType], page: Int, limit: Int) -> Single<[SearchResult]> {
			searchInvoked = true
			searchParameters = (query, types, page, limit)
			return Single.error(error)
		}
	}

	final class Repository: SearchRepository {
		private let results: [SearchResult]
		var searchInvoked = false
		var searchParameters: (query: String, types: [SearchType], page: Int, limit: Int)?

		init(results: [SearchResult] = [SearchResult]()) {
			self.results = results
		}

		func search(query: String, types: [SearchType], page: Int, limit: Int) -> Single<[SearchResult]> {
			searchInvoked = true
			searchParameters = (query, types, page, limit)
			return Single.just(results)
		}
	}

	final class Interactor: SearchInteractor {
		var searchInvoked = false
		var searchParameters: (query: String, types: [SearchType])?
		private let repository: SearchRepository

		init(repository: SearchRepository) {
			self.repository = repository
		}

		func search(query: String, types: [SearchType]) -> Single<[SearchResult]> {
			searchInvoked = true
			searchParameters = (query, types)

			let lowercaseQuery = query.lowercased()

			return repository.search(query: query, types: [.movie], page: 0, limit: 50).map { results -> [SearchResult] in
				results.filter { result -> Bool in
					let containsMovie = result.movie?.title?.lowercased().contains(lowercaseQuery) ?? false
					let containsShow = result.show?.title?.lowercased().contains(lowercaseQuery) ?? false
					return containsMovie || containsShow
				}
			}
		}
	}
}
