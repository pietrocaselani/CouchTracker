import RxMoya
import RxSwift
import TraktSwift

public final class MovieDetailsAPIRepository: MovieDetailsRepository {
  private let traktProvider: TraktProvider
  private let schedulers: Schedulers

  public init(traktProvider: TraktProvider, schedulers: Schedulers) {
    self.traktProvider = traktProvider
    self.schedulers = schedulers
  }

  public func fetchDetails(movieId: String) -> Observable<Movie> {
    traktProvider.movies.rx.request(.summary(movieId: movieId, extended: .full))
      .observeOn(schedulers.networkScheduler)
      .map(Movie.self)
      .asObservable()
  }

  public func watched(movieId: Int) -> Single<WatchedMovieResult> {
    let params = HistoryParameters(type: .movies, id: movieId)

    return traktProvider.sync.rx.request(.history(params: params))
      .observeOn(schedulers.networkScheduler)
      .map([BaseMovie].self)
      .map { movies -> WatchedMovieResult in
        guard let movie = movies.first else {
          return WatchedMovieResult.unwatched
        }

        return WatchedMovieResult.watched(movie: movie)
      }.catchErrorJustReturn(WatchedMovieResult.unwatched)
  }

  public func addToHistory(movie: MovieEntity) -> Single<SyncMovieResult> {
    let syncMovie = SyncMovie(ids: movie.ids)
    let syncItems = SyncItems(movies: [syncMovie])

    return performSyncRequest(target: .addToHistory(items: syncItems))
  }

  public func removeFromHistory(movie: MovieEntity) -> Single<SyncMovieResult> {
    let syncMovie = SyncMovie(ids: movie.ids)
    let syncItems = SyncItems(movies: [syncMovie])

    return performSyncRequest(target: .removeFromHistory(items: syncItems))
  }

  private func performSyncRequest(target: Sync) -> Single<SyncMovieResult> {
    traktProvider.sync.rx.request(target)
      .filterSuccessfulStatusAndRedirectCodes()
      .map { _ -> SyncMovieResult in SyncMovieResult.success }
      .catchError { Single.just(SyncMovieResult.fail(error: $0)) }
  }
}
