import Moya
import RxSwift
import TraktSwift

public final class TraktGenreRepository: GenreRepository {
  private let traktProvider: TraktProvider
  private let dataSource: GenreDataSource
  private let schedulers: Schedulers

  public init(traktProvider: TraktProvider, dataSource: GenreDataSource, schedulers: Schedulers) {
    self.traktProvider = traktProvider
    self.dataSource = dataSource
    self.schedulers = schedulers
  }

  public func fetchMoviesGenres() -> Single<[Genre]> {
    return fetchGenres(mediaType: .movies)
  }

  public func fetchShowsGenres() -> Single<[Genre]> {
    return fetchGenres(mediaType: .shows)
  }

  private func fetchGenres(mediaType: GenreType) -> Single<[Genre]> {
    let apiObservable = fetchGenreFromAPI(mediaType: mediaType)

    return dataSource.fetchGenres()
      .ifEmpty(switchTo: apiObservable)
      .catchError { _ in apiObservable }
  }

  private func fetchGenreFromAPI(mediaType: GenreType) -> Single<[Genre]> {
    return traktProvider.genres.rx.request(.list(mediaType))
      .map([Genre].self)
      .observeOn(schedulers.dataSourceScheduler)
      .do(onSuccess: { [weak self] genres in
        try self?.dataSource.save(genres: genres)
      }).observeOn(schedulers.networkScheduler)
  }
}
