import RxSwift
import TraktSwift

public protocol GenreRepository {
  func fetchMoviesGenres() -> Observable<[Genre]>
  func fetchShowsGenres() -> Observable<[Genre]>
}
