import RxSwift
import TraktSwift

protocol GenreRepository {
  func fetchMoviesGenres() -> Observable<[Genre]>
  func fetchShowsGenres() -> Observable<[Genre]>
}
