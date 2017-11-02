import Moya
import RxSwift
import TraktSwift

final class TraktGenreRepository: GenreRepository {

//  private let cache: BasicCache<Genres, [Genre]>
  private let traktProvider: TraktProvider

  init(traktProvider: TraktProvider) {
    self.traktProvider = traktProvider
//    let provider = traktProvider.genres

//    self.cache = MemoryCacheLevel<Genres, NSData>()
//        .compose(DiskCacheLevel<Genres, NSData>())
//        .compose(MoyaFetcher(provider: provider))
//        .transformValues(JSONArrayTransfomer<Genre>())
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
