import RxSwift

public struct SyncEnvironment {
  public static let live = SyncEnvironment()

  public var api = APIEnvironment()
}

public struct APIEnvironment {
  public var syncWatchedShows: ([Extended]) -> Single<[BaseShow]> = syncWatchedShows(extended:)
  public var watchedProgress: (WatchedProgressOptions, ShowIds) -> Single<BaseShow> = watchedProgress(options:showIds:)
  public var seasonsForShow: (ShowIds, [Extended]) -> Single<[Season]> = seasonsForShow(showIds:extended:)
  public var genres: () -> Single<Set<Genre>> = genresForMoviesAndShows
}
