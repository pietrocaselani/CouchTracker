import Carlos
import Moya
import RxSwift
import Trakt

final class TraktGenreRepository: GenreRepository {

  private let cache: BasicCache<Genres, [Genre]>

  init(traktProvider: TraktProvider) {
    let provider = traktProvider.genres

    self.cache = MemoryCacheLevel<Genres, NSData>()
        .compose(DiskCacheLevel<Genres, NSData>())
        .compose(MoyaFetcher(provider: provider))
        .transformValues(JSONArrayTransfomer<Genre>())
  }

  func fetchMoviesGenres() -> Observable<[Genre]> {
    return fetchGenres(mediaType: .movies)
  }

  func fetchShowsGenres() -> Observable<[Genre]> {
    return fetchGenres(mediaType: .shows)
  }

  private func fetchGenres(mediaType: GenreType) -> Observable<[Genre]> {
    return cache.get(.list(mediaType)).asObservable()
  }
}
