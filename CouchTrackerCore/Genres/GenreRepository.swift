import RxSwift
import TraktSwift

public protocol GenreRepository {
  func fetchMoviesGenres() -> Single<[Genre]>
  func fetchShowsGenres() -> Single<[Genre]>
}
