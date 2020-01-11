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

var trakt: Trakt = { badTrakt! }()

var badTrakt: Trakt?

public func setupSyncModule(trakt: Trakt) -> (SyncOptions) -> Observable<WatchedShow> {
  badTrakt = trakt
  return { options in
    startSync(options)
  }
}

#if DEBUG
public var Current = SyncEnvironment.live
#else
public let Current = SyncEnvironment.live
#endif
