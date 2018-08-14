import RxSwift
import TraktSwift

public final class ShowSeasonsAPIRepository: ShowSeasonsRepository {
  private let trakt: TraktProvider

  public init(trakt: TraktProvider) {
    self.trakt = trakt
  }

  public func fetchShowSeasons(showIds _: ShowIds, extended _: Extended) -> Single<[Season]> {
    trakt.shows.rx.request(.)
    return Single.just([])
  }
}
