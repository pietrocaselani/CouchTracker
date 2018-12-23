@testable import CouchTrackerCore
import RxSwift
import TraktSwift

final class GenreRepositoryMock: GenreRepository {
  func fetchShowsGenres() -> Single<[Genre]> {
    return Single.just(TraktEntitiesMock.createShowsGenresMock())
  }

  func fetchMoviesGenres() -> Single<[Genre]> {
    return Single.just(TraktEntitiesMock.createMoviesGenresMock())
  }
}
