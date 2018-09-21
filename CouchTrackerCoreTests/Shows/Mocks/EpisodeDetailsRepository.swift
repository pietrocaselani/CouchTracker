import CouchTrackerCore
import RxSwift
import TraktSwift

final class EpisodeDetailsRepositoryMock: EpisodeDetailsRepository {
  func fetchDetailsOf(episode: Int, season _: Int, from _: ShowIds, extended _: Extended) -> Single<Episode> {
    let episode: Episode = TraktEntitiesMock.decodeTraktJSON(with: "trakt_episodes_summary")
    return Single.just(episode)
  }
}
