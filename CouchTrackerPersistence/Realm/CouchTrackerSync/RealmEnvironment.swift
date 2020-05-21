import RxSwift

public struct RealmEnvironment {
  public static let live = RealmEnvironment()

  public var watchedShows: () -> Single<RealmObjectState<[ShowRealm]>> = allWatchedShows
  public var saveShows: ([ShowRealm]) -> Completable = saveShows(shows:)
}
