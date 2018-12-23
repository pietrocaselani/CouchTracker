import RxSwift

public protocol WatchedShowsDataSource {
  func fetchWatchedShows() -> Observable<[WatchedShowEntity]>
  func addWatched(shows: [WatchedShowEntity]) throws
}
