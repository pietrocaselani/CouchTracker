import TraktSwift
import RxSwift
import Moya

enum SyncError: Error {
  case showIsNil
}

struct WatchedProgressOptions {
  let hidden: Bool
  let specials: Bool
  let countSpecials: Bool

  init(hidden: Bool = false, specials: Bool = false, countSpecials: Bool = false) {
    self.hidden = hidden
    self.specials = specials
    self.countSpecials = countSpecials
  }
}

struct SyncOptions {
  let watchedProgress: WatchedProgressOptions

  init(watchedProgress: WatchedProgressOptions = WatchedProgressOptions()) {
    self.watchedProgress = watchedProgress
  }
}

func startSync(options: SyncOptions) -> Observable<BaseShow> {
  return syncMain(options)
}

private func syncMain(_ options: SyncOptions) -> Observable<BaseShow> {
  return Current.syncWatchedShows(.noSeasons)
    .flatMap { Observable.from($0) }
    .flatMap { watchedProgress(options: options.watchedProgress, baseShow: $0) }
}

private func watchedProgress(options: WatchedProgressOptions, baseShow: BaseShow) -> Observable<BaseShow> {
  guard let show = baseShow.show else { return Observable.error(SyncError.showIsNil) }
  return Current.watchedProgress(options, show.ids).map { merge(syncBaseShow: baseShow, progressBaseShow: $0) }
}

private func merge(syncBaseShow: BaseShow, progressBaseShow: BaseShow) -> BaseShow {
  BaseShow(show: syncBaseShow.show,
           seasons: progressBaseShow.seasons,
           lastCollectedAt: nil,
           listedAt: nil,
           plays: syncBaseShow.plays,
           lastWatchedAt: progressBaseShow.lastWatchedAt,
           aired: progressBaseShow.aired,
           completed: progressBaseShow.completed,
           hiddenSeasons: progressBaseShow.hiddenSeasons,
           nextEpisode: progressBaseShow.nextEpisode,
           lastEpisode: progressBaseShow.lastEpisode)
}
