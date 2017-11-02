import Moya
import RxSwift
import TraktSwift

final class MovieDetailsCacheRepository: MovieDetailsRepository {
//  private let cache: BasicCache<Movies, Movie>
  private let traktProvider: TraktProvider

  init(traktProvider: TraktProvider) {
//    let moviesProvider = traktProvider.movies
    self.traktProvider = traktProvider

//    self.cache = MemoryCacheLevel<Movies, NSData>()
//        .compose(DiskCacheLevel<Movies, NSData>())
//        .compose(MoyaFetcher(provider: moviesProvider))
//        .transformValues(JSONObjectTransfomer<Movie>())
  }

  func fetchDetails(movieId: String) -> Observable<Movie> {
    return traktProvider.movies.rx.request(.summary(movieId: movieId, extended: .full)).map(Movie.self).asObservable()
//    return cache.get(.summary(movieId: movieId, extended: .full)).asObservable()
  }
}
