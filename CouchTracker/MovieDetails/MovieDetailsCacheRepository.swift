import Carlos
import Moya
import RxSwift
import Trakt

final class MovieDetailsCacheRepository: MovieDetailsRepository {
  private let cache: BasicCache<Movies, Movie>

  init(traktProvider: TraktProvider) {
    let moviesProvider = traktProvider.movies

    self.cache = MemoryCacheLevel<Movies, NSData>()
        .compose(DiskCacheLevel<Movies, NSData>())
        .compose(MoyaFetcher(provider: moviesProvider))
        .transformValues(JSONObjectTransfomer<Movie>())
  }

  func fetchDetails(movieId: String) -> Observable<Movie> {
    return cache.get(.summary(movieId: movieId, extended: .full)).asObservable()
  }
}
