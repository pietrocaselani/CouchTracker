import TraktSwift
import RxSwift
import Moya

func syncWatchedShows() -> Single<[BaseShow]> {
  return Current.trakt.sync.rx.request(.watched(type: .shows, extended: .noSeasons)).map([BaseShow].self)
}
