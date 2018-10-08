import RxSwift
import TraktSwift

public struct ShowSyncOptions: Hashable {
  public let hideSpecials: Bool
  public let syncSeasons: Bool

  public init(hideSpecials: Bool, syncSeasons: Bool) {
    self.hideSpecials = hideSpecials
    self.syncSeasons = syncSeasons
  }
}

public protocol ShowWatchedProgressSynchronizer {
  func syncShowWatchedProgress(showId: ShowIds, options: ShowSyncOptions) -> Single<WatchedShowEntity>
}

public protocol WatchedShowsSynchronizer {
  func syncWatchedShows(extended: Extended, options: ShowSyncOptions) -> Observable<WatchedShowEntity>
}

public protocol MoviesGenreSynchronizer {
  func syncMoviesGenres() -> Single<[Genre]>
}

public protocol ShowsGenreSynchronizer {
  func syncShowsGenres() -> Single<[Genre]>
}

public protocol GenreSynchronizer: MoviesGenreSynchronizer, ShowsGenreSynchronizer {}
