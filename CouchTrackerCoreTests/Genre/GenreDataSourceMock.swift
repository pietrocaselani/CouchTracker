import CouchTrackerCore
import TraktSwift
import RxSwift

final class GenreDataSourceMock: GenreDataSource {
    private let type: GenreType

    var fetchGenresInvokedCount = 0
    var saveGenresInvokedCount = 0
    var saveGenresParameter: [Genre]?

    init(type: GenreType) {
        self.type = type
    }

    func fetchGenres() -> Maybe<[Genre]> {
        fetchGenresInvokedCount += 1

        let genres = type == .movies ? TraktEntitiesMock.createMoviesGenresMock() : TraktEntitiesMock.createShowsGenresMock()
        return Maybe.just(genres)
    }

    func save(genres: [Genre]) throws {
        saveGenresInvokedCount += 1
        saveGenresParameter = genres
    }
}