import TraktSwift
import RxSwift

private let trakt = Trakt(builder: TraktBuilder {
  $0.clientId = Secrets.Trakt.clientId
  $0.clientSecret = Secrets.Trakt.clientSecret
  $0.redirectURL = Secrets.Trakt.redirectURL
  $0.callbackQueue = DispatchQueue(label: "NetworkQueue", qos: .default)
})

struct APIEnviront {

}

struct DatabaseEnv {
}

struct SyncEnvironment {
  var syncWatchedShows: ([Extended]) -> Observable<[BaseShow]>
  var watchedProgress: (WatchedProgressOptions, ShowIds) -> Observable<BaseShow>
  var seasonsForShow: (ShowIds, [Extended]) -> Observable<[Season]>
  var genres: () -> Observable<Set<Genre>>
}

extension SyncEnvironment {
  static let live = SyncEnvironment(
    syncWatchedShows: syncWatchedShows(extended:),
    watchedProgress: watchedProgress(options:showIds:),
    seasonsForShow: seasonsForShow(showIds:extended:),
    genres: genresForMoviesAndShows
  )
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

private func seasonsForShow(showIds: ShowIds, extended: [Extended]) -> Observable<[Season]> {
  return trakt.seasons.rx
    .request(.summary(showId: showIds.realId, extended: extended))
    .map([Season].self)
    .asObservable()
}

private func genresForMoviesAndShows() -> Observable<Set<Genre>> {
  let genresForType: (GenreType) -> Single<[Genre]> = { type in
    trakt.genres.rx.request(.list(type)).map([Genre].self)
  }

  return Single.zip(genresForType(.movies), genresForType(.shows)) { (movies, shows) in
    Set(movies + shows)
  }.asObservable()
}
