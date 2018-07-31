import Moya
import RxSwift
import TraktSwift

public final class TraktGenreRepository: GenreRepository {
  private let traktProvider: TraktProvider
  private let schedulers: Schedulers

  public init(traktProvider: TraktProvider, schedulers: Schedulers) {
    self.traktProvider = traktProvider
    self.schedulers = schedulers
  }

  public func fetchMoviesGenres() -> Observable<[Genre]> {
    return fetchGenres(mediaType: .movies)
  }

  public func fetchShowsGenres() -> Observable<[Genre]> {
    return fetchGenres(mediaType: .shows)
  }

  private func fetchGenres(mediaType: GenreType) -> Observable<[Genre]> {
    return traktProvider.genres.rx.request(.list(mediaType))
      .observeOn(schedulers.networkScheduler)
      .map([Genre].self)
      .asObservable()
  }
}
