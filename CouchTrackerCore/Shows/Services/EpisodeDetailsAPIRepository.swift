import RxSwift
import TraktSwift

public final class EpisodeDetailsAPIRepository: EpisodeDetailsRepository {
  private let trakt: TraktProvider

  public init(trakt: TraktProvider) {
    self.trakt = trakt
  }

  public func fetchDetailsOf(episode: Int, season: Int, from showId: ShowIds, extended: Extended) -> Single<Episode> {
    let target = Episodes.summary(showId: showId.realId, season: season, episode: episode, extended: extended)
    return trakt.episodes.rx.request(target).do(onSuccess: { response in
      print("PC response is empty? \(response.data.isEmpty)")
    }).map(Episode.self)
  }
}
