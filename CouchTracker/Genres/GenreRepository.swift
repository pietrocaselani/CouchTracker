import RxSwift
import Trakt

protocol GenreRepository {
  func fetchMoviesGenres() -> Observable<[Genre]>
  func fetchShowsGenres() -> Observable<[Genre]>
}
