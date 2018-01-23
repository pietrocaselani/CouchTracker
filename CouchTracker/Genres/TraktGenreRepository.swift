import Moya
import RxSwift
import TraktSwift

final class TraktGenreRepository: GenreRepository {
  private let traktProvider: TraktProvider

  init(traktProvider: TraktProvider) {
    self.traktProvider = traktProvider
  }

  func fetchMoviesGenres() -> Observable<[Genre]> {
    return fetchGenres(mediaType: .movies)
  }

  func fetchShowsGenres() -> Observable<[Genre]> {
    return fetchGenres(mediaType: .shows)
  }

  private func fetchGenres(mediaType: GenreType) -> Observable<[Genre]> {
    return traktProvider.genres.rx.request(.list(mediaType)).map([Genre].self).asObservable()
  }
}
