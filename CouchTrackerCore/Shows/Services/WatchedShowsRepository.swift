import RxSwift
import TraktSwift

public protocol WatchedShowsRepository {
  func fetchWatchedShows(extended: Extended) -> Single<[BaseShow]>
}
