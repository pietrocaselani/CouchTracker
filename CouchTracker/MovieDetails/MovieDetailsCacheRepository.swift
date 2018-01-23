import Moya
import RxSwift
import TraktSwift

final class MovieDetailsCacheRepository: MovieDetailsRepository {
  private let traktProvider: TraktProvider

  init(traktProvider: TraktProvider) {
    self.traktProvider = traktProvider
  }

  func fetchDetails(movieId: String) -> Observable<Movie> {
    return traktProvider.movies.rx.request(.summary(movieId: movieId, extended: .full)).map(Movie.self).asObservable()
  }
}
