import RxSwift
import TraktSwift

public protocol EpisodeSynchronizer {
  func syncDetailsOf(episode: Int, season: Int, from: ShowIds, extended: Extended) -> Single<WatchedEpisodeEntity>
}

public protocol ShowWatchedProgressSynchronizer {
  func syncShowWatchedProgress(showId: ShowIds, hideSpecials: Bool) -> Single<WatchedShowEntity>
}

public protocol SeasonsWatchedProgressSynchronizer {
  func syncWatchedSeasons(using ids: ShowIds) -> Single<[WatchedSeasonEntity]>
}

public protocol MoviesGenreSynchronizer {
  func syncMoviesGenres() -> Single<[Genre]>
}

public protocol ShowsGenreSynchronizer {
  func syncShowsGenres() -> Single<[Genre]>
}

public protocol GenreSynchronizer: MoviesGenreSynchronizer, ShowsGenreSynchronizer {}
