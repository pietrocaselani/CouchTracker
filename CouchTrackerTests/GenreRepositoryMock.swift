import RxSwift
import TraktSwift

func createMoviesGenresMock() -> [Genre] {
  let jsonArray = JSONParser.toArray(data: Genres.list(.movies).sampleData)
  return try! jsonArray.map { try Genre(JSON: $0) }
}

func createShowsGenresMock() -> [Genre] {
  let jsonArray = JSONParser.toArray(data: Genres.list(.shows).sampleData)
  return try! jsonArray.map { try Genre(JSON: $0) }
}

final class GenreRepositoryMock: GenreRepository {
  func fetchShowsGenres() -> Observable<[Genre]> {
    return Observable.just(createShowsGenresMock())
  }

  func fetchMoviesGenres() -> Observable<[Genre]> {
    return Observable.just(createMoviesGenresMock())
  }
}
