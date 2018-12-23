import RxSwift
import TraktSwift

public final class ShowSeasonsAPIRepository: ShowSeasonsRepository {
  private let trakt: TraktProvider

  public init(trakt: TraktProvider) {
    self.trakt = trakt
  }

  public func fetchShowSeasons(showIds: ShowIds, extended: Extended) -> Single<[Season]> {
    return trakt.seasons.rx.request(.summary(showId: showIds.realId, exteded: extended))
      .filterSuccessfulStatusCodes()
      .map([Season].self)
  }
}
