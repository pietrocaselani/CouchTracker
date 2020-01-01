import TraktSwift
import RxSwift

let traktBuilder = TraktBuilder {
  $0.clientId = Secrets.Trakt.clientId
  $0.clientSecret = Secrets.Trakt.clientSecret
  $0.redirectURL = Secrets.Trakt.redirectURL
  $0.callbackQueue = DispatchQueue(label: "NetworkQueue", qos: .default)
}

private let trakt = Trakt(builder: traktBuilder)

struct SyncEnvironment {
  var syncWatchedShows: ([Extended]) -> Observable<[BaseShow]>
  var watchedProgress: (WatchedProgressOptions, ShowIds) -> Observable<BaseShow>
}

extension SyncEnvironment {
  static let live = SyncEnvironment(syncWatchedShows: syncWatchedShows(extended:), watchedProgress: watchedProgress(options:showIds:))
}

#if DEBUG
var Current = SyncEnvironment.live
#else
let Current = SyncEnvironment.live
#endif

private func syncWatchedShows(extended: [Extended]) -> Observable<[BaseShow]> {
  return trakt.sync.rx.request(.watched(type: .shows, extended: extended)).map([BaseShow].self).asObservable()
}

private func watchedProgress(options: WatchedProgressOptions, showIds: ShowIds) -> Observable<BaseShow> {
  return trakt.shows.rx.request(
    .watchedProgress(
      showId: showIds.realId,
      hidden: options.countSpecials,
      specials: options.countSpecials,
      countSpecials: options.countSpecials
    )
  ).map(BaseShow.self).asObservable()
}
