import RxSwift
import TraktSwift

public protocol EpisodeDetailsRepository {
  func fetchDetailsOf(episode: Int, season: Int, from showId: ShowIds, extended: Extended) -> Single<Episode>
}
