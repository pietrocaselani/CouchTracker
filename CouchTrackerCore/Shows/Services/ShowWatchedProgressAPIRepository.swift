import RxSwift
import TraktSwift

public final class ShowWatchedProgressAPIRepository: ShowWatchedProgressRepository {
  private let trakt: TraktProvider

  public init(trakt: TraktProvider) {
    self.trakt = trakt
  }

  public func fetchShowWatchedProgress(showId: ShowIds, hideSpecials: Bool) -> Single<BaseShow> {
    let target = Shows.watchedProgress(showId: showId.realId,
                                       hidden: !hideSpecials,
                                       specials: !hideSpecials,
                                       countSpecials: !hideSpecials)
    return trakt.shows.rx.request(target).filterSuccessfulStatusCodes().map(BaseShow.self)
  }
}
