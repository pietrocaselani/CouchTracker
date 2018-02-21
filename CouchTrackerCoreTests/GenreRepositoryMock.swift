import RxSwift
import TraktSwift
@testable import CouchTrackerCore

final class GenreRepositoryMock: GenreRepository {
	func fetchShowsGenres() -> Observable<[Genre]> {
		return Observable.just(TraktEntitiesMock.createShowsGenresMock())
	}

	func fetchMoviesGenres() -> Observable<[Genre]> {
		return Observable.just(TraktEntitiesMock.createMoviesGenresMock())
	}
}
