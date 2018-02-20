import RxSwift
import TraktSwift

final class SearchService: SearchInteractor {
	private let repository: SearchRepository

	init(repository: SearchRepository) {
		self.repository = repository
	}

	func searchMovies(query: String) -> Observable<[SearchResult]> {
		return repository.search(query: query, types: [.movie], page: 0, limit: 50)
	}
}
