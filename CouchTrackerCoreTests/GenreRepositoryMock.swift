@testable import CouchTrackerCore
import RxSwift
import TraktSwift

final class GenreRepositoryMock: GenreRepository {
    func fetchShowsGenres() -> Observable<[Genre]> {
        return Observable.just(TraktEntitiesMock.createShowsGenresMock())
    }

    func fetchMoviesGenres() -> Observable<[Genre]> {
        return Observable.just(TraktEntitiesMock.createMoviesGenresMock())
    }
}
