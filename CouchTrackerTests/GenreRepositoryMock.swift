import RxSwift
import TraktSwift

func createMoviesGenresMock() -> [Genre] {
  return try! JSONDecoder().decode([Genre].self, from: Genres.list(.movies).sampleData)
}

func createShowsGenresMock() -> [Genre] {
  return try! JSONDecoder().decode([Genre].self, from: Genres.list(.shows).sampleData)
}

final class GenreRepositoryMock: GenreRepository {
  func fetchShowsGenres() -> Observable<[Genre]> {
    return Observable.just(createShowsGenresMock())
  }

  func fetchMoviesGenres() -> Observable<[Genre]> {
    return Observable.just(createMoviesGenresMock())
  }
}
